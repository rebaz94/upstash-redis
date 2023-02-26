import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/pipeline.dart';

import 'json_arrappend.dart';
import 'json_arrindex.dart';
import 'json_arrinsert.dart';
import 'json_arrlen.dart';
import 'json_arrpop.dart';
import 'json_arrtrim.dart';
import 'json_clear.dart';
import 'json_del.dart';
import 'json_forget.dart';
import 'json_get.dart';
import 'json_mget.dart';
import 'json_numincrby.dart';
import 'json_nummultby.dart';
import 'json_objkeys.dart';
import 'json_objlen.dart';
import 'json_resp.dart';
import 'json_set.dart';
import 'json_strappend.dart';
import 'json_strlen.dart';
import 'json_toggle.dart';
import 'json_type.dart';

const $ = r'$';

class RedisJson {
  RedisJson(Requester client) : _client = client;

  final Requester _client;

  /// @see https://redis.io/commands/json.arrappend
  Future<List<int?>> arrappend<TData>(
    String key,
    String path,
    TData values, [
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return JsonArrAppendCommand<TData>(key, path, values).exec(_client);
  }

  /// @see https://redis.io/commands/json.arrindex
  Future<List<int?>> arrindex<TValue>(
    String key,
    String path,
    TValue value, {
    num? start,
    num? stop,
    CommandOption<List<dynamic>, List<int?>>? opts,
  }) {
    return JsonArrIndexCommand<TValue>(
      key,
      path,
      value,
      start: start,
      stop: stop,
      opts: opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/json.arrinsert
  Future<List<int?>> arrinsert<TData>(
    String key,
    String path,
    int index,
    List<TData> values, [
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return JsonArrInsertCommand<TData>(key, path, index, values, opts)
        .exec(_client);
  }

  /// @see https://redis.io/commands/json.arrlen
  Future<List<int?>> arrlen(
    String key, [
    String? path,
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return JsonArrLenCommand(key, path, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.arrpop
  Future<List<TData?>> arrpop<TData>(
    String key, [
    String? path,
    int? index,
    CommandOption<List<dynamic>, List<TData?>>? opts,
  ]) {
    return JsonArrPopCommand<TData>(key, path, index, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.arrtrim
  Future<List<int?>> arrtrim(
    String key, [
    String? path,
    int? start,
    int? stop,
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return JsonArrTrimCommand(key, path, start, stop, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.clear
  Future<int> clear(
    String key, [
    String? path,
    CommandOption<int, int>? opts,
  ]) {
    return JsonClearCommand(key, path, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.del
  Future<int> del(
    String key, [
    String? path,
    CommandOption<int, int>? opts,
  ]) {
    return JsonDelCommand(key, path, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.forget
  Future<int> forget(
    String key, [
    String? path,
    CommandOption<int, int>? opts,
  ]) {
    return JsonForgetCommand(key, path, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.get
  Future<TData?> get<TData>(
    String key,
    List<String> path, {
    String? indent,
    String? newline,
    String? space,
    CommandOption<dynamic, TData?>? opts,
  }) {
    return JsonGetCommand<TData>(
      key,
      path,
      indent: indent,
      newline: newline,
      space: space,
      opts: opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/json.mget
  Future<TData> mget<TData>(
    List<String> keys,
    String path, {
    CommandOption<TData, TData>? opts,
  }) {
    return JsonMGetCommand<TData>(keys, path, opts: opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.numincrby
  Future<List<num?>> numincrby(
    String key,
    String path,
    num value, [
    CommandOption<String?, List<num?>>? opts,
  ]) {
    return JsonNumIncrByCommand(key, path, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.nummultby
  Future<List<num?>> nummultby(
    String key,
    String path,
    num value, [
    CommandOption<String?, List<num?>>? opts,
  ]) {
    return JsonNumMultByCommand(key, path, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.objkeys
  Future<List<List<String>?>> objkeys(
    String key, [
    String? path,
    CommandOption<List<List<String>?>, List<List<String>?>>? opts,
  ]) {
    return JsonObjKeysCommand(key, path, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.objlen
  Future<List<int?>> objlen(
    String key, [
    String? path,
    CommandOption<List<int?>, List<int?>>? opts,
  ]) {
    return JsonObjLenCommand(key, path, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.resp
  Future<List<int?>> resp(
    String key, [
    String? path,
    CommandOption<List<int?>, List<int?>>? opts,
  ]) {
    return JsonRespCommand(key, path, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.set
  Future<String?> set<TData>(
    String key,
    String path,
    TData value, {
    bool? nx,
    bool? xx,
    CommandOption<String?, String?>? opts,
  }) {
    return JsonSetCommand<TData>(key, path, value, nx: nx, xx: xx)
        .exec(_client);
  }

  /// @see https://redis.io/commands/json.strappend
  Future<List<int?>> strappend(
    String key,
    String path,
    String value, [
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return JsonStrAppendCommand(key, path, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.strlen
  Future<List<int?>> strlen(
    String key, [
    String? path,
    CommandOption<List<int?>, List<int?>>? opts,
  ]) {
    return JsonStrLenCommand(key, path, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.toggle
  Future<List<int?>> toggle(
    String key,
    String path, [
    CommandOption<List<int>, List<int>>? opts,
  ]) {
    return JsonToggleCommand(key, path, opts).exec(_client);
  }

  /// @see https://redis.io/commands/json.type
  Future<List<String>> type(
    String key, [
    String? path,
    CommandOption<List<String>, List<String>>? opts,
  ]) {
    return JsonTypeCommand(key, path, opts).exec(_client);
  }
}

class RedisJsonPipeline {
  RedisJsonPipeline(this._chain);

  /// Pushes a command into the pipeline and returns a chainable instance of the pipeline
  final Pipeline Function<T>(Command<dynamic, T>) _chain;

  /// @see https://redis.io/commands/json.arrappend
  Pipeline arrappend<TData>(
    String key,
    String path,
    TData values, [
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return _chain(JsonArrAppendCommand<TData>(key, path, values));
  }

  /// @see https://redis.io/commands/json.arrindex
  Pipeline arrindex<TValue>(
    String key,
    String path,
    TValue value, {
    num? start,
    num? stop,
    CommandOption<List<dynamic>, List<int?>>? opts,
  }) {
    return _chain(JsonArrIndexCommand<TValue>(key, path, value,
        start: start, stop: stop, opts: opts));
  }

  /// @see https://redis.io/commands/json.arrinsert
  Pipeline arrinsert<TData>(
    String key,
    String path,
    int index,
    List<TData> values, [
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return _chain(JsonArrInsertCommand<TData>(key, path, index, values, opts));
  }

  /// @see https://redis.io/commands/json.arrlen
  Pipeline arrlen(
    String key, [
    String? path,
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return _chain(JsonArrLenCommand(key, path, opts));
  }

  /// @see https://redis.io/commands/json.arrpop
  Pipeline arrpop<TData>(
    String key, [
    String? path,
    int? index,
    CommandOption<List<dynamic>, List<TData?>>? opts,
  ]) {
    return _chain(JsonArrPopCommand<TData>(key, path, index, opts));
  }

  /// @see https://redis.io/commands/json.arrtrim
  Pipeline arrtrim(
    String key, [
    String? path,
    int? start,
    int? stop,
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return _chain(JsonArrTrimCommand(key, path, start, stop, opts));
  }

  /// @see https://redis.io/commands/json.clear
  Pipeline clear(
    String key, [
    String? path,
    CommandOption<int, int>? opts,
  ]) {
    return _chain(JsonClearCommand(key, path, opts));
  }

  /// @see https://redis.io/commands/json.del
  Pipeline del(
    String key, [
    String? path,
    CommandOption<int, int>? opts,
  ]) {
    return _chain(JsonDelCommand(key, path, opts));
  }

  /// @see https://redis.io/commands/json.forget
  Pipeline forget(
    String key, [
    String? path,
    CommandOption<int, int>? opts,
  ]) {
    return _chain(JsonForgetCommand(key, path, opts));
  }

  /// @see https://redis.io/commands/json.get
  Pipeline get<TData>(
    String key,
    List<String> path, {
    String? indent,
    String? newline,
    String? space,
    CommandOption<dynamic, TData?>? opts,
  }) {
    return _chain(JsonGetCommand<TData>(key, path,
        indent: indent, newline: newline, space: space, opts: opts));
  }

  /// @see https://redis.io/commands/json.mget
  Pipeline mget<TData>(
    List<String> keys,
    String path, {
    CommandOption<TData, TData>? opts,
  }) {
    return _chain(JsonMGetCommand<TData>(keys, path, opts: opts));
  }

  /// @see https://redis.io/commands/json.numincrby
  Pipeline numincrby(
    String key,
    String path,
    num value, [
    CommandOption<String?, List<num?>>? opts,
  ]) {
    return _chain(JsonNumIncrByCommand(key, path, value, opts));
  }

  /// @see https://redis.io/commands/json.nummultby
  Pipeline nummultby(
    String key,
    String path,
    num value, [
    CommandOption<String?, List<num?>>? opts,
  ]) {
    return _chain(JsonNumMultByCommand(key, path, value, opts));
  }

  /// @see https://redis.io/commands/json.objkeys
  Pipeline objkeys(
    String key, [
    String? path,
    CommandOption<List<List<String>?>, List<List<String>?>>? opts,
  ]) {
    return _chain(JsonObjKeysCommand(key, path, opts));
  }

  /// @see https://redis.io/commands/json.objlen
  Pipeline objlen(
    String key, [
    String? path,
    CommandOption<List<int?>, List<int?>>? opts,
  ]) {
    return _chain(JsonObjLenCommand(key, path, opts));
  }

  /// @see https://redis.io/commands/json.resp
  Pipeline resp(
    String key, [
    String? path,
    CommandOption<List<int?>, List<int?>>? opts,
  ]) {
    return _chain(JsonRespCommand(key, path, opts));
  }

  /// @see https://redis.io/commands/json.set
  Pipeline set<TData>(
    String key,
    String path,
    TData value, {
    bool? nx,
    bool? xx,
    CommandOption<String?, String?>? opts,
  }) {
    return _chain(JsonSetCommand<TData>(key, path, value, nx: nx, xx: xx));
  }

  /// @see https://redis.io/commands/json.strappend
  Pipeline strappend(
    String key,
    String path,
    String value, [
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return _chain(JsonStrAppendCommand(key, path, value, opts));
  }

  /// @see https://redis.io/commands/json.strlen
  Pipeline strlen(
    String key, [
    String? path,
    CommandOption<List<int?>, List<int?>>? opts,
  ]) {
    return _chain(JsonStrLenCommand(key, path, opts));
  }

  /// @see https://redis.io/commands/json.toggle
  Pipeline toggle(
    String key,
    String path, [
    CommandOption<List<int>, List<int>>? opts,
  ]) {
    return _chain(JsonToggleCommand(key, path, opts));
  }

  /// @see https://redis.io/commands/json.type
  Pipeline type(
    String key, [
    String? path,
    CommandOption<List<String>, List<String>>? opts,
  ]) {
    return _chain(JsonTypeCommand(key, path, opts));
  }
}
