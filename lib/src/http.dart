import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:upstash_redis/src/upstash_error.dart';

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

  final TResult? result;
  final bool undefined;
  final String? error;
}

abstract class Requester {
  Future<UpstashResponse<TResult>> request<TResult>({
    List<String>? path,
    Object? body,
  });
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
  });

  final Map<String, String>? headers;
  final String baseUrl;
  final Options? options;
  final RetryConfig? retry;
}

class UpstashHttpClient implements Requester {
  UpstashHttpClient(HttpClientConfig config)
      : baseUrl = config.baseUrl.replaceAll(RegExp(r'/$'), ''),
        headers = {"Content-Type": "application/json", ...?config.headers},
        options = Options(backend: config.options?.backend),
        retry = config.retry == null
            ? Retry(attempts: 5)
            : Retry(
                attempts: config.retry!.retries,
                backoff: config.retry!.backoff,
              );

  final String baseUrl;
  final Map<String, String> headers;
  final Options? options;
  final Retry retry;

  @override
  Future<UpstashResponse<TResult>> request<TResult>({List<String>? path, Object? body}) async {
    final uri = Uri.parse([baseUrl, ...(path ?? [])].join('/'));
    final encodedBody = body != null ? json.encode(body) : null;

    http.Response? result;
    dynamic error;

    for (int i = 0; i <= retry.attempts; i++) {
      try {
        result = await http.post(
          uri,
          headers: headers,
          body: encodedBody,
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

    final UpstashResponse<TResult> bodyResult;
    try {
      final jsonData = Map<String, dynamic>.from(json.decode(result.body));
      bodyResult = UpstashResponse<TResult>.fromJson(jsonData);
    } catch (e, stack) {
      throw UpstashDecodingError('decoding failed', e, stack);
    }

    if (result.statusCode < 200 || result.statusCode >= 300) {
      throw UpstashError(bodyResult.error ?? 'unknown error');
    }

    return bodyResult;
  }
}
