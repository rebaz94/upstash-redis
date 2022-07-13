import 'dart:convert';

import 'package:upstash_redis/src/http.dart';
import 'package:upstash_redis/src/upstash_error.dart';
import 'package:upstash_redis/src/utils.dart';

export 'package:upstash_redis/src/http.dart' show Requester;
export 'package:upstash_redis/src/commands/aggregate_type.dart';

typedef Serialize = String Function(dynamic data);
typedef Deserialize<TResult, TData> = TData Function(TResult result);

String defaultSerializer(dynamic data) {
  if (data is String) return data;
  return json.encode(data);
}

TData _castedDeserializer<TResult, TData>(TResult result) {
  return (result as dynamic) as TData;
}

class CommandOption<TResult, TData> {
  CommandOption({this.deserialize, this.automaticDeserialization = true});

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
        command = command.map(serialize).toList();

  final List<String> command;
  final Serialize serialize;
  final Deserialize<TResult, TData> deserialize;

  Future<TData> exec(Requester client) async {
    final response = await client.request<TResult>(body: command);
    final result = checkUpstashResponse<TResult>(response);
    return deserialize(result as TResult);
  }

  UpstashResponse<TResult> createUpstashResponseFrom(
    Map<String, dynamic> json,
  ) {
    return UpstashResponse<TResult>.fromJson(json);
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
