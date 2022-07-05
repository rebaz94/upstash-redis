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
  Future<int> bitpos(String key, int start, [int? end, CommandOption<int, int>? opts]) {
    return BitPosCommand(key, start, end, opts).exec(_client);
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

  /// @see https://redis.io/commands/get
  Future<TData?> get<TData>(String key, [CommandOption<dynamic, TData>? opts]) {
    return GetCommand<TData>([key], opts).exec(_client);
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
