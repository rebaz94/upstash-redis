import 'dart:convert';

import 'package:upstash_redis/src/http.dart';
import 'package:upstash_redis/src/upstash_error.dart';
import 'package:upstash_redis/src/utils.dart';

export 'package:upstash_redis/src/http.dart' show Requester;
export 'package:upstash_redis/src/commands/aggregate_type.dart';

typedef Serialize = dynamic /*String | num | bool*/ Function(dynamic data);
typedef Deserialize<TResult, TData> = TData Function(TResult result);

dynamic defaultSerializer(dynamic data) {
  if (data is String || data is num || data is bool) {
    return data;
  }

  return json.encode(data);
}

TData _castedDeserializer<TResult, TData>(TResult result) {
  return (result as dynamic) as TData;
}

class CommandOption<TResult, TData> {
  CommandOption({this.deserialize, this.automaticDeserialization = true});

  factory CommandOption.by(Deserialize<TResult, TData>? deserialize) {
    return CommandOption(deserialize: deserialize);
  }

  factory CommandOption.fromListStringToNumericBy(String type) {
    if (type == 'String') {
      return _listStrToStringNullable as CommandOption<TResult, TData>;
    } else if (type == 'int') {
      return _listStrToIntNullable as CommandOption<TResult, TData>;
    } else if (type == 'double') {
      return _listStrToDoubleNullable as CommandOption<TResult, TData>;
    } else if (type == 'num') {
      return _listStrToNumNullable as CommandOption<TResult, TData>;
    }

    return CommandOption();
  }

  static final _listStrToStringNullable =
      CommandOption<List<dynamic>, List<String?>>(
    deserialize: (result) => List<String>.from(result),
  );

  static final _listStrToIntNullable = CommandOption<List<dynamic>, List<int?>>(
    deserialize: CommandOption.defaultListOfNullableStringToIntDeserializer,
  );

  static final _listStrToDoubleNullable =
      CommandOption<List<dynamic>, List<double?>>(
    deserialize: CommandOption.defaultListOfNullableStringToDoubleDeserializer,
  );

  static final _listStrToNumNullable = CommandOption<List<dynamic>, List<num?>>(
    deserialize: CommandOption.defaultListOfNullableStringToNumDeserializer,
  );

  static List<int?> defaultListOfNullableStringToIntDeserializer(
      List<dynamic> results) {
    return results.map((e) {
      if (e is String) return int.tryParse(e);
      if (e is int) return e;

      return null;
    }).toList();
  }

  static List<double?> defaultListOfNullableStringToDoubleDeserializer(
      List<dynamic> results) {
    return results.map((e) {
      if (e is String) return double.tryParse(e);
      if (e is double) return e;

      return null;
    }).toList();
  }

  static List<num?> defaultListOfNullableStringToNumDeserializer(
      List<dynamic> results) {
    return results.map((e) {
      if (e is String) return num.tryParse(e);
      if (e is num) return e;

      return null;
    }).toList();
  }

  /// Custom deserialize
  final Deserialize<TResult, TData>? deserialize;

  /// Automatically try to deserialize the returned data from upstash using `json.decode`
  ///
  /// default is true
  final bool automaticDeserialization;
}

/// Command offers default (de)serialization and the exec method to all commands.
///
/// TData represents what the user will enter or receive,
/// TResult is the raw data returned from upstash, which may need to be transformed or parsed.
abstract class Command<TResult, TData> {
  Command(
    /*String|unknown*/
    List<dynamic> command, [
    CommandOption<TResult, TData>? opts,
    Deserialize<TResult, TData>? deserialize,
    this.serialize = defaultSerializer,
  ])  : deserialize = (opts == null || opts.automaticDeserialization)
            ? opts?.deserialize ?? deserialize ?? parseResponse
            : _castedDeserializer,
        command = command.map((c) => serialize(c)).toList();

  final List<dynamic> command;
  final Serialize serialize;
  final Deserialize<TResult, TData> deserialize;

  Future<TData> exec(Requester client) async {
    final response = await client.request<TResult>(body: command);
    final result = checkUpstashResponse<TResult>(response);
    return deserialize(result as TResult);
  }

  UpstashResponse<TResult> createUpstashResponseFrom(
    Map<String, dynamic> json,
    bool isBase64Response,
  ) {
    return isBase64Response
        ? UpstashResponse<TResult>.fromJsonWithBase64(json)
        : UpstashResponse<TResult>.fromJson(json);
  }

  TData decodeValueFrom(TResult result) {
    return deserialize(result);
  }
}

TResult? checkUpstashResponse<TResult>(UpstashResponse<TResult> response) {
  final error = response.error;
  final result = response.result;

  if (error != null) {
    throw UpstashError(error);
  }

  if (response.undefined) {
    throw Exception('Request did not return a result');
  }

  return result;
}
