import 'dart:io';

import 'package:upstash_redis/src/commands/mod.dart';
import 'package:upstash_redis/src/http.dart';

class RedisOptions {
  const RedisOptions({
    this.automaticDeserialization = true,
  });

  /// Automatically try to deserialize the returned data from upstash using `json.decode`
  final bool automaticDeserialization;
}

/// Serverless redis client for upstash.
class Redis {
  Redis._(this._client, this.opts);

  /// Create a new redis client
  factory Redis({
    required String url,
    required String token,
    RetryConfig? retryConfig,
    RedisOptions opts = const RedisOptions(),
  }) {
    if (url.startsWith(' ') || url.endsWith(' ') || url.contains(RegExp(r'[\r\n]'))) {
      print('The redis url contains whitespace or newline, which can cause errors!');
    }
    if (token.startsWith(' ') || token.endsWith(' ') || token.contains(RegExp(r'[\r\n]'))) {
      print('The redis token contains whitespace or newline, which can cause errors!');
    }

    return Redis._(
      UpstashHttpClient(
        HttpClientConfig(
          baseUrl: url,
          headers: {'authorization': 'Bearer $token'},
          retry: retryConfig,
        ),
      ),
      CommandOption(automaticDeserialization: opts.automaticDeserialization),
    );
  }

  factory Redis.fromEnv({
    RetryConfig? retryConfig,
    RedisOptions opts = const RedisOptions(),
  }) {
    final url = Platform.environment['UPSTASH_REDIS_REST_URL'] ?? '';
    final token = Platform.environment['UPSTASH_REDIS_REST_TOKEN'] ?? '';

    if (url.isEmpty) {
      throw Exception('Unable to find environment variable: `UPSTASH_REDIS_REST_URL`.');
    }

    if (token.isEmpty) {
      throw Exception('Unable to find environment variable: `UPSTASH_REDIS_REST_TOKEN`.');
    }

    return Redis(
      url: url,
      token: token,
      retryConfig: retryConfig,
      opts: opts,
    );
  }

  final Requester _client;
  final CommandOption<dynamic, dynamic>? opts;

  Future<TData> run<TResult, TData>(Command<TResult, TData> command) {
    return command.exec(_client);
  }

  /// @see https://redis.io/commands/append
  Future<int> append(String key, String value, [CommandOption<int, int>? opts]) {
    return AppendCommand(key, value).exec(_client);
  }

  /// @see https://redis.io/commands/bitcount
  Future<int> bitcount(String key, {int? start, int? end, CommandOption<int, int>? opts}) {
    return BitCountCommand(key, start: start, end: end, opts: opts).exec(_client);
  }

  /// @see https://redis.io/commands/bitop
  Future<int> bitop(
    BitOp op,
    String destinationKey,
    List<String> sourceKeys, [
    CommandOption<int, int>? opts,
  ]) {
    return BitOpCommand(op, destinationKey, sourceKeys, opts).exec(_client);
  }

  /// @see https://redis.io/commands/bitpos
  Future<int> bitpos(String key, int bit, [int? start, int? end, CommandOption<int, int>? opts]) {
    return BitPosCommand(key, bit, start, end, opts).exec(_client);
  }

  /// @see https://redis.io/commands/dbsize
  Future<int> dbsize([CommandOption<int, int>? opts]) {
    return DbSizeCommand(opts).exec(_client);
  }

  /// @see https://redis.io/commands/decr
  Future<int> decr(String key, [CommandOption<int, int>? opts]) {
    return DecrCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/decrby
  Future<int> decrby(String key, int decrement, [CommandOption<int, int>? opts]) {
    return DecrByCommand(key, decrement, opts).exec(_client);
  }

  /// @see https://redis.io/commands/del
  Future<int> del(List<String> keys, [CommandOption<int, int>? opts]) {
    return DelCommand(keys, opts).exec(_client);
  }

  /// @see https://redis.io/commands/echo
  Future<String> echo(String message, [CommandOption<String, String>? opts]) {
    return EchoCommand(message, opts).exec(_client);
  }

  /// @see https://redis.io/commands/eval
  Future<TData> eval<TArgs, TData>(
    String script,
    List<String> keys,
    List<TArgs> args, [
    CommandOption<dynamic, TData>? opts,
  ]) {
    return EvalCommand<TArgs, TData>(script, keys, args, opts).exec(_client);
  }

  /// @see https://redis.io/commands/evalsha
  Future<TData> evalsha<TArgs, TData>(
    String sha,
    List<String> keys,
    List<TArgs> args, [
    CommandOption<dynamic, TData>? opts,
  ]) {
    return EvalshaCommand<TArgs, TData>(sha, keys, args, opts).exec(_client);
  }

  /// @see https://redis.io/commands/exists
  Future<int> exists<TData>(List<String> keys, [CommandOption<int, int>? opts]) {
    return ExistsCommand(keys).exec(_client);
  }

  /// @see https://redis.io/commands/expire
  Future<int> expire(String key, int seconds, [CommandOption<int, int>? opts]) {
    return ExpireCommand(key, seconds, opts).exec(_client);
  }

  /// @see https://redis.io/commands/expireat
  Future<int> expireat(String key, int unix, [CommandOption<int, int>? opts]) {
    return ExpireCommand(key, unix, opts).exec(_client);
  }

  /// @see https://redis.io/commands/flushall
  Future<String> flushall({bool? async, CommandOption<String, String>? opts}) {
    return FlushAllCommand(async: async, opts: opts).exec(_client);
  }

  /// @see https://redis.io/commands/flushdb
  Future<String> flushdb({bool? async, CommandOption<String, String>? opts}) {
    return FlushDbCommand(async: async, opts: opts).exec(_client);
  }

  /// @see https://redis.io/commands/get
  Future<TData?> get<TData>(String key, [CommandOption<dynamic, TData>? opts]) {
    return GetCommand<TData>([key], opts).exec(_client);
  }

  /// @see https://redis.io/commands/getbit
  Future<int> getbit(String key, int offset, [CommandOption<int, int>? opts]) {
    return GetBitCommand(key, offset, opts).exec(_client);
  }

  /// @see https://redis.io/commands/getrange
  Future<String> getrange(String key, int start, int end, [CommandOption<String, String>? opts]) {
    return GetRangeCommand(key, start, end, opts).exec(_client);
  }

  /// @see https://redis.io/commands/getset
  Future<TData?> getset<TData>(String key, TData value, [CommandOption<dynamic, TData>? opts]) {
    return GetSetCommand<TData>(key, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hget
  Future<TData?> hget<TData>(String key, String field, [CommandOption<Object?, TData?>? opts]) {
    return HGetCommand(key, field, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hgetall
  Future<Map<String, TData?>?> hgetall<TData>(
    String key,
    String field, [
    CommandOption<Object?, Map<String, TData?>>? opts,
  ]) {
    return HGetAllCommand<TData>(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hincrby
  Future<int> hincrby(
    String key,
    String field,
    int increment, [
    CommandOption<int, int>? opts,
  ]) {
    return HIncrByCommand(key, field, increment, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hincrbyfloat
  Future<num> hincrbyfloat(
    String key,
    String field,
    num increment, [
    CommandOption<num, num>? opts,
  ]) {
    return HIncrByFloatCommand(key, field, increment, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hkeys
  Future<List<String>> hkeys(String key, [CommandOption<List<String>, List<String>>? opts]) {
    return HKeysCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hlen
  Future<List<String>> hlen(String key, [CommandOption<List<String>, List<String>>? opts]) {
    return HKeysCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hmget
  Future<Map<String, TData?>?> hmget<TData>(
    String key,
    List<String> fields, [
    CommandOption<List<String>, Map<String, TData?>>? opts,
  ]) {
    return HMGetCommand(key, fields, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hmset
  Future<String> hmset<TData>(String key, Map<String, TData> kv,
      [CommandOption<String, String>? opts]) {
    return HMSetCommand(key, kv, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hscan
  Future<List<dynamic>> hscan(
    String key,
    int cursor, {
    String? match,
    int? count,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    return HScanCommand(key, cursor, match: match, count: count, opts: opts).exec(_client);
  }

  /// @see https://redis.io/commands/hdel
  Future<int> hdel(String key, String field, [CommandOption<int, int>? opts]) {
    return HDelCommand(key, field, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hexists
  Future<int> hexists(String key, String field, [CommandOption<int, int>? opts]) {
    return HExistsCommand(key, field, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hset
  Future<int> hset<TData>(String key, Map<String, TData> kv, [CommandOption<int, int>? opts]) {
    return HSetCommand<TData>(key, kv, opts).exec(_client);
  }

  /// @see https://redis.io/commands/script-load
  Future<String> scriptLoad(String script, [CommandOption<String, String>? opts]) {
    return ScripLoadCommand(script, opts).exec(_client);
  }

  /// @see https://redis.io/commands/set
  Future<String?> set<TData>(
    String key,
    TData value, {
    int? ex,
    int? px,
    bool? nx,
    bool? xx,
    CommandOption<String, String>? opts,
  }) {
    return SetCommand<TData, String>(
      key,
      value,
      ex: ex,
      px: px,
      nx: nx,
      xx: xx,
      opts: opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/setbit
  Future<int> setbit(String key, int offset, int bit, [CommandOption<int, int>? opts]) {
    return SetBitCommand(key, offset, bit, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zadd
  Future<num?> zadd<TData>(
    String key, {
    num? score,
    TData? member,
    List<ScoreMember<TData>> scores = const [],
    bool? ch,
    bool? incr,
    bool? nx,
    bool? xx,
    CommandOption<num?, num?>? cmdOpts,
  }) {
    final allScores = [...scores];
    if (score != null && member != null) {
      allScores.insert(0, ScoreMember(score: score, member: member));
    }

    return ZAddCommand(key, allScores, ch: ch, incr: incr, nx: nx, xx: xx, cmdOpts: cmdOpts)
        .exec(_client);
  }

  /// @see https://redis.io/commands/zrem
  Future<int> zrem<TData>(String key, List<TData> members, [CommandOption<int, int>? opts]) {
    return ZRemCommand<TData>(key, members, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zscore
  Future<num?> zscore<TData>(String key, TData member, [CommandOption<String, num>? opts]) {
    return ZScoreCommand(key, member, opts).exec(_client);
  }
}
