import 'dart:convert';
import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:upstash_redis/src/commands/mod.dart';
import 'package:upstash_redis/src/upstash_error.dart';

extension on String {
  // ignore: unused_element
  String slice([int start = 0, int? end]) {
    final subject = this;

    int realEnd;
    int realStart = start < 0 ? subject.length + start : start;
    if (end is! int) {
      realEnd = subject.length;
    } else {
      realEnd = end < 0 ? subject.length + end : end;
    }

    return subject.substring(realStart, realEnd);
  }
}

class UpstashResponse<TResult> {
  const UpstashResponse({
    this.result,
    this.undefined = false,
    this.error,
  });

  static final _implicitDecode = {
    (List<String>).toString(): (result) => List<String>.from(result as List),
    (List<String?>).toString(): (result) => List<String?>.from(result as List),
    (List<int>).toString(): (result) => List<int>.from(result as List),
    (List<int?>).toString(): (result) => List<int?>.from(result as List),
    (List<double>).toString(): (result) => List<double>.from(result as List),
    (List<double?>).toString(): (result) => List<double?>.from(result as List),
    (List<num>).toString(): (result) => List<num>.from(result as List),
    (List<num?>).toString(): (result) => List<num?>.from(result as List),
    (List<bool>).toString(): (result) => List<bool>.from(result as List),
    (List<bool?>).toString(): (result) => List<bool?>.from(result as List),
  };

  factory UpstashResponse.fromJson(Map<String, dynamic> json) {
    final result = json['result'];
    final hasResult = json.containsKey('result');
    final type = TResult.toString();

    if (!hasResult) {
      return UpstashResponse(
        result: null,
        undefined: true,
        error: json['error'] as String?,
      );
    }

    dynamic converted = result;
    final decoderFn = _implicitDecode[type];
    if (decoderFn != null) {
      converted = decoderFn(result);
    }

    return UpstashResponse(
      result: converted,
      undefined: false,
      error: json['error'] as String?,
    );
  }

  factory UpstashResponse.fromJsonWithBase64(Map<String, dynamic> json) {
    Object? result = json['result'];
    final hasResult = json.containsKey('result');
    final type = TResult.toString();

    if (!hasResult) {
      return UpstashResponse(
        result: null,
        undefined: true,
        error: json['error'] as String?,
      );
    }

    result =
        result is List ? result.map((e) => decode(e)).toList() : decode(result);

    final decoderFn = _implicitDecode[type];
    dynamic converted = result;
    if (decoderFn != null) {
      converted = decoderFn(result);
    }

    return UpstashResponse(
      result: converted,
      undefined: false,
      error: json['error'] as String?,
    );
  }

  static customBase64Decode(String b64) {
    // String dec = '';
    // try {
    //   dec = String.fromCharCodes(base64Decode(base64.normalize(b64)))
    //       .split('')
    //       .map((s) => '%${('00${s.codeUnits.map((c) => c.toRadixString(16)).join()}').slice(-2)}')
    //       .join();
    // } catch (e) {
    //   print('Unable to decode base64 [$base64]: ${e.toString()}');
    //   return dec;
    // }
    //
    // try {
    //   return Uri.decodeComponent(dec);
    // } catch (e) {
    //   print('Unable to decode URI [$dec]: ${e.toString()}');
    //   return dec;
    // }
    try {
      final bytes = base64.decode(b64);
      return utf8.decode(bytes);
    } catch (e) {
      return b64;
    }
  }

  static Object? decode(Object? result) {
    if (result == null) {
      return result;
    } else if (result is num) {
      result = result;
    } else if (result is String) {
      result = result == 'OK' ? 'OK' : customBase64Decode(result);
    } else if (result is List) {
      result = result.map((value) {
        if (value is String) {
          return customBase64Decode(value);
        } else if (value is List) {
          return value.map((v) => customBase64Decode(v)).toList();
        } else {
          return value;
        }
      }).toList();
    }
    return result;
  }

  final TResult? result;
  final bool undefined;
  final String? error;
}

abstract class Requester {
  Future<UpstashResponse<TResult>> request<TResult>({
    List<String>? path,
    Object? body,
  });

  Future<List<UpstashResponse<dynamic>>> requestPipeline({
    List<String>? path,
    Object? body,
    required List<Command<dynamic, dynamic>> commands,
  });

  void close();
}

class RetryConfig {
  const RetryConfig({
    this.retries = 5,
    this.backoff = _defaultBackoff,
  });

  /// The number of retries to attempt before giving up.
  ///
  /// @default 5
  final int retries;

  /// A backoff function receives the current retry count and returns a number in milliseconds to wait before retrying.
  ///
  /// @default
  /// math.exp(retryCount) * 50
  final double Function(int retryCount) backoff;
}

double _defaultBackoff(int retryCount) {
  return math.exp(retryCount) * 50;
}

class Retry {
  const Retry({
    required this.attempts,
    this.backoff = _defaultBackoff,
  });

  /// The number of retries to attempt before giving up.
  final int attempts;

  /// A backoff function receives the current retry count and returns a number in milliseconds to wait before retrying.
  final double Function(int retryCount) backoff;
}

class Options {
  Options({
    this.backend,
  });

  final String? backend;
}

class HttpClientConfig {
  HttpClientConfig({
    this.headers,
    required this.baseUrl,
    this.options,
    this.retry,
    this.isBase64Response = false,
    this.agent,
    this.reuseHttpClient = true,
  });

  final Map<String, String>? headers;
  final String baseUrl;
  final Options? options;

  /// Configure the retry behaviour in case of network errors
  final RetryConfig? retry;

  /// Due to the nature of dynamic and custom data, it is possible to write data to redis that is not
  /// valid json and will therefore cause errors when deserializing. This used to happen very
  /// frequently with non-utf8 data, such as emojis.
  ///
  /// By default we will therefore encode the data as base64 on the server, before sending it to the
  /// client. The client will then decode the base64 data and parse it as utf8.
  ///
  /// For very large entries, this can add a few milliseconds, so if you are sure that your data is
  /// valid utf8, you can disable this behaviour by setting this option to false.
  ///
  /// Here's what the response body looks like:
  ///
  /// ```json
  /// {
  ///  result?: "base64-encoded",
  ///  error?: string
  /// }
  /// ```
  ///
  /// @default "base64"
  final bool isBase64Response;
  final Object? agent;
  final bool reuseHttpClient;
}

class UpstashHttpClient implements Requester {
  UpstashHttpClient(HttpClientConfig config)
      : baseUrl = config.baseUrl.replaceAll(RegExp(r'/$'), ''),
        headers = {
          'Content-Type': 'application/json',
          if (config.isBase64Response) 'Upstash-Encoding': 'base64',
          ...?config.headers,
        },
        options = Options(backend: config.options?.backend),
        agent = config.agent,
        retry = config.retry == null
            ? Retry(attempts: 5)
            : Retry(
                attempts: config.retry!.retries,
                backoff: config.retry!.backoff,
              ),
        isBase64Response = config.isBase64Response,
        reuseHttpClient = config.reuseHttpClient;

  final String baseUrl;
  final Map<String, String> headers;
  final bool isBase64Response;
  final Options? options;
  final Object? agent;
  final Retry retry;
  final bool reuseHttpClient;
  http.Client? _httpClient;

  @override
  Future<UpstashResponse<TResult>> request<TResult>({
    List<String>? path,
    Object? body,
  }) async {
    http.Response? result = await _makeRequest(path: path, body: body);

    final UpstashResponse<TResult> bodyResult;
    try {
      final jsonData = Map<String, dynamic>.from(json.decode(result.body));
      bodyResult = isBase64Response
          ? UpstashResponse<TResult>.fromJsonWithBase64(jsonData)
          : UpstashResponse<TResult>.fromJson(jsonData);
    } catch (e, stack) {
      throw UpstashDecodingError('decoding failed', e, stack);
    }

    if (result.statusCode < 200 || result.statusCode >= 300) {
      throw UpstashError(bodyResult.error ?? 'unknown error');
    }

    return bodyResult;
  }

  @override
  Future<List<UpstashResponse>> requestPipeline({
    List<String>? path,
    Object? body,
    required List<Command<dynamic, dynamic>> commands,
  }) async {
    http.Response? result = await _makeRequest(path: path, body: body);

    final List<UpstashResponse<dynamic>> bodyResult;
    try {
      bodyResult = (json.decode(result.body) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .mapIndexed((i, e) =>
              commands[i].createUpstashResponseFrom(e, isBase64Response))
          .toList();
    } catch (e, stack) {
      throw UpstashDecodingError('decoding failed', e, stack);
    }

    if (result.statusCode < 200 || result.statusCode >= 300) {
      throw UpstashError('unknown error');
    }

    return bodyResult;
  }

  Future<http.Response> _makeRequest({List<String>? path, Object? body}) async {
    final uri = Uri.parse([baseUrl, ...(path ?? [])].join('/'));
    final encodedBody = body != null ? json.encode(body) : null;

    http.Response? result;
    dynamic error;

    for (int i = 0; i <= retry.attempts; i++) {
      try {
        result = await _withClient(
          (client) => client.post(
            uri,
            headers: headers,
            body: encodedBody,
          ),
        );
        break;
      } catch (e) {
        error = e;
        await Future.delayed(Duration(milliseconds: retry.backoff(i).toInt()));
      }
    }

    if (result == null) {
      if (error != null) {
        throw error;
      }

      throw Exception('Exhausted all retries');
    }

    return result;
  }

  Future<T> _withClient<T>(Future<T> Function(http.Client) fn) async {
    if (reuseHttpClient) {
      return fn(_httpClient ??= http.Client());
    }

    final client = http.Client();
    try {
      return await fn(client);
    } finally {
      client.close();
    }
  }

  @override
  void close() {
    _httpClient?.close();
  }
}
