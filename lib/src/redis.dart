import 'dart:io';

import 'package:upstash_redis/src/commands/append.dart';
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

  /// @see https://redis.io/commands/append
  Future<int> append(String key, String value, [CommandOption<int, int>? opts]) {
    return AppendCommand(key, value).exec(_client);
  }

  /// @see https://redis.io/commands/del
  Future<int> del(List<String> keys, [CommandOption<int, int>? opts]) {
    return DelCommand(keys, opts).exec(_client);
  }

  /// @see https://redis.io/commands/get
  Future<TData?> get<TData>(String key) {
    return GetCommand<TData>([key]).exec(_client);
  }

  /// @see https://redis.io/commands/set
  Future<String?> set<TData>(
    String key,
    TData value, {
    int? ex,
    int? px,
    bool? nx,
    bool? xx,
  }) {
    return SetCommand<TData, String>(key, value, ex: ex, px: px, nx: nx, xx: xx).exec(_client);
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
  Future<int> zrem<TData>(String key, List<TData> members) {
    return ZRemCommand<TData>(key, members).exec(_client);
  }

  /// @see https://redis.io/commands/zscore
  Future<num?> zscore<TData>(String key, TData member) {
    return ZScoreCommand(key, member).exec(_client);
  }
}
