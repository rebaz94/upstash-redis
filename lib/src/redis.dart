import 'package:upstash_redis/src/commands/mod.dart';
import 'package:upstash_redis/src/http.dart';
import 'package:upstash_redis/src/platform/platform.dart';
import 'package:upstash_redis/src/pipeline.dart';
import 'package:upstash_redis/src/script.dart';

class RedisOptions {
  const RedisOptions({
    this.automaticDeserialization = true,
  });

  /// Automatically try to deserialize the returned data from upstash using `json.decode`
  final bool automaticDeserialization;
}

/// Serverless redis client for upstash.
class Redis {
  Redis._(this._client);

  factory Redis.byClient(Requester client) {
    return Redis._(client);
  }

  /// Create a new redis client
  factory Redis({
    required String url,
    required String token,
    RetryConfig? retryConfig,
    RedisOptions opts = const RedisOptions(),
  }) {
    if (url.startsWith(' ') ||
        url.endsWith(' ') ||
        url.contains(RegExp(r'[\r\n]'))) {
      print(
        'The redis url contains whitespace or newline, which can cause errors!',
      );
    }
    if (token.startsWith(' ') ||
        token.endsWith(' ') ||
        token.contains(RegExp(r'[\r\n]'))) {
      print(
        'The redis token contains whitespace or newline, which can cause errors!',
      );
    }

    return Redis._(
      UpstashHttpClient(
        HttpClientConfig(
          baseUrl: url,
          headers: {'authorization': 'Bearer $token'},
          retry: retryConfig,
        ),
      ),
    );
  }

  factory Redis.fromEnv({
    RetryConfig? retryConfig,
    RedisOptions opts = const RedisOptions(),
  }) {
    final platform = PlatformEnv();
    final url = platform['UPSTASH_REDIS_REST_URL'] ?? '';
    final token = platform['UPSTASH_REDIS_REST_TOKEN'] ?? '';

    if (url.isEmpty) {
      throw Exception(
        'Unable to find environment variable: `UPSTASH_REDIS_REST_URL`.',
      );
    }

    if (token.isEmpty) {
      throw Exception(
        'Unable to find environment variable: `UPSTASH_REDIS_REST_TOKEN`.',
      );
    }

    return Redis(
      url: url,
      token: token,
      retryConfig: retryConfig,
      opts: opts,
    );
  }

  final Requester _client;

  /// Creates a new script.
  ///
  /// Scripts offer the ability to optimistically try to execute a script without having to send the
  /// entire script to the server. If the script is loaded on the server, it tries again by sending
  /// the entire script. Afterwards, the script is cached on the server.
  ///
  /// @example
  /// ```dart
  /// final redis = Redis();
  /// final scriptSource = "return ARGV[1];";
  /// final scriptSha1 = sha1.convert(utf8.encode(scriptSource)).toString(); // generate using crypto package
  /// final script = redis.createScript<string>(scriptSource, scriptSha1);
  /// final arg1 = await script.eval([], ["Hello World"]);
  /// assert(arg1 == "Hello World");
  /// ```
  Script createScript<T>(String script, String sha1) =>
      Script<T>(this, script, sha1);

  /// Create a new pipeline that allows you to send requests in bulk.
  Pipeline pipeline() => Pipeline(client: _client);

  /// Create a new transaction to allow executing multiple steps atomically.
  ///
  /// All the commands in a transaction are serialized and executed sequentially. A request sent by
  /// another client will never be served in the middle of the execution of a Redis Transaction. This
  /// guarantees that the commands are executed as a single isolated operation.
  ///
  /// @see Pipeline
  multi() => Pipeline(client: _client, multiExec: true);

  Future<TData> run<TResult, TData>(Command<TResult, TData> command) {
    return command.exec(_client);
  }

  Future<List<dynamic>> runs(
    List<Command> commands, {
    bool eagerError = false,
    bool sequentialExecution = false,
  }) async {
    if (sequentialExecution) {
      final result = [];
      for (final c in commands) {
        result.add(await c.exec(_client));
      }
      return result;
    }
    return Future.wait(
      commands.map((c) => c.exec(_client)),
      eagerError: eagerError,
    );
  }

  /// @see https://redis.io/commands/append
  Future<int> append(
    String key,
    String value, [
    CommandOption<int, int>? opts,
  ]) {
    return AppendCommand(key, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/bitcount
  Future<int> bitcount(
    String key, {
    int? start,
    int? end,
    CommandOption<int, int>? opts,
  }) {
    return BitCountCommand(
      key,
      start: start,
      end: end,
      opts: opts,
    ).exec(_client);
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
  Future<int> bitpos(
    String key,
    int bit, [
    int? start,
    int? end,
    CommandOption<int, int>? opts,
  ]) {
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
  Future<int> decrby(
    String key,
    int decrement, [
    CommandOption<int, int>? opts,
  ]) {
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
  Future<int> exists(List<String> keys, [CommandOption<int, int>? opts]) {
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
    return GetCommand<TData>(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/getbit
  Future<int> getbit(String key, int offset, [CommandOption<int, int>? opts]) {
    return GetBitCommand(key, offset, opts).exec(_client);
  }

  /// @see https://redis.io/commands/getrange
  Future<String> getrange(
    String key,
    int start,
    int end, [
    CommandOption<String, String>? opts,
  ]) {
    return GetRangeCommand(key, start, end, opts).exec(_client);
  }

  /// @see https://redis.io/commands/getset
  Future<TData?> getset<TData>(
    String key,
    TData value, [
    CommandOption<dynamic, TData>? opts,
  ]) {
    return GetSetCommand<TData>(key, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hget
  Future<TData?> hget<TData>(String key, String field,
      [CommandOption<dynamic, TData?>? opts]) {
    return HGetCommand<TData>(key, field, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hgetall
  Future<Map<String, TData?>?> hgetall<TData>(
    String key, [
    CommandOption<dynamic, Map<String, TData?>>? opts,
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
  Future<List<String>> hkeys(
    String key, [
    CommandOption<List<String>, List<String>>? opts,
  ]) {
    return HKeysCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hlen
  Future<List<String>> hlen(
    String key, [
    CommandOption<List<String>, List<String>>? opts,
  ]) {
    return HKeysCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hmget
  Future<Map<String, TData?>?> hmget<TData>(
    String key,
    List<String> fields, [
    CommandOption<List<String>, Map<String, TData?>>? opts,
  ]) {
    return HMGetCommand<TData>(key, fields, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hmset
  Future<String> hmset<TData>(String key, Map<String, TData> kv,
      [CommandOption<String, String>? opts]) {
    return HMSetCommand<TData>(key, kv, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hscan
  Future<List<dynamic>> hscan(
    String key,
    int cursor, {
    String? match,
    int? count,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    return HScanCommand(
      key,
      cursor,
      match: match,
      count: count,
      opts: opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/hdel
  Future<int> hdel(String key, String field, [CommandOption<int, int>? opts]) {
    return HDelCommand(key, field, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hexists
  Future<int> hexists(
    String key,
    String field, [
    CommandOption<int, int>? opts,
  ]) {
    return HExistsCommand(key, field, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hset
  Future<int> hset<TData>(
    String key,
    Map<String, TData> kv, [
    CommandOption<int, int>? opts,
  ]) {
    return HSetCommand<TData>(key, kv, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hsetnx
  Future<int> hsetnx<TData>(String key, String field, TData value,
      [CommandOption<int, int>? opts]) {
    return HSetNXCommand<TData>(key, field, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hstrlen
  Future<int> hstrlen(
    String key,
    String field, [
    CommandOption<int, int>? opts,
  ]) {
    return HStrLenCommand(key, field, opts).exec(_client);
  }

  /// @see https://redis.io/commands/hvals
  Future<List<TData>> hvals<TData>(
    String key, [
    CommandOption<List<TData>, List<TData>>? opts,
  ]) {
    return HValsCommand<TData>(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/incr
  Future<int> incr(String key, [CommandOption<int, int>? opts]) {
    return IncrCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/incrby
  Future<int> incrby(String key, int value, [CommandOption<int, int>? opts]) {
    return IncrByCommand(key, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/incrbyfloat
  Future<num> incrbyfloat(
    String key,
    num value, [
    CommandOption<num, num>? opts,
  ]) {
    return IncrByFloatCommand(key, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/keys
  Future<List<String>> keys(
    String pattern, [
    CommandOption<List<String>, List<String>>? opts,
  ]) {
    return KeysCommand(pattern, opts).exec(_client);
  }

  /// @see https://redis.io/commands/lindex
  Future<TData?> lindex<TData>(
    String key,
    int index, [
    CommandOption<Object?, TData?>? opts,
  ]) {
    return LIndexCommand<TData>(key, index, opts).exec(_client);
  }

  /// @see https://redis.io/commands/linsert
  Future<int> linsert<TData>(
    String key,
    IDirection direction,
    TData pivot,
    TData value, [
    CommandOption<int, int>? opts,
  ]) {
    return LInsertCommand<TData>(
      key,
      direction,
      pivot,
      value,
      opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/llen
  Future<int> llen(String key, [CommandOption<int, int>? opts]) {
    return LLenCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/lpop
  Future<TData?> lpop<TData>(
    String key, [
    CommandOption<Object?, TData?>? opts,
  ]) {
    return LPopCommand<TData>(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/lpos
  Future<TData> lpos<TData>(
    String key,
    dynamic element, {
    int? rank,
    int? count,
    int? maxLen,
    CommandOption<TData, TData>? opts,
  }) {
    return LPosCommand<TData>(
      key,
      element,
      rank: rank,
      count: count,
      maxLen: maxLen,
      opts: opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/lpush
  Future<int> lpush<TData>(
    String key,
    List<TData> elements, [
    CommandOption<int, int>? opts,
  ]) {
    return LPushCommand<TData>(key, elements, opts).exec(_client);
  }

  /// @see https://redis.io/commands/lpushx
  Future<int> lpushx<TData>(
    String key,
    List<TData> elements, [
    CommandOption<int, int>? opts,
  ]) {
    return LPushCommand<TData>(key, elements, opts).exec(_client);
  }

  /// @see https://redis.io/commands/lrange
  Future<List<TData>> lrange<TData>(String key, int start, int end,
      [CommandOption<List<String?>, List<TData>>? opts]) {
    return LRangeCommand<TData>(key, start, end, opts).exec(_client);
  }

  /// @see https://redis.io/commands/lrem
  Future<int> lrem<TData>(
    String key,
    int count,
    TData value, [
    CommandOption<int, int>? opts,
  ]) {
    return LRemCommand<TData>(key, count, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/lset
  Future<String> lset<TData>(
    String key,
    int index,
    TData value, [
    CommandOption<String, String>? opts,
  ]) {
    return LSetCommand<TData>(key, index, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/ltrim
  Future<String> ltrim(
    String key,
    int start,
    int end, [
    CommandOption<String, String>? opts,
  ]) {
    return LTrimCommand(key, start, end, opts).exec(_client);
  }

  /// @see https://redis.io/commands/mget
  Future<List<TData?>> mget<TData>(
    List<String> keys, [
    CommandOption<List<String?>, List<TData?>>? opts,
  ]) {
    return MGetCommand<TData>(keys, opts).exec(_client);
  }

  /// @see https://redis.io/commands/mset
  Future<String> mset<TData>(
    Map<String, TData> kv, [
    CommandOption<String, String>? opts,
  ]) {
    return MSetCommand<TData>(kv, opts).exec(_client);
  }

  /// @see https://redis.io/commands/msetnx
  Future<int> msetnx<TData>(
    Map<String, TData> kv, [
    CommandOption<int, int>? opts,
  ]) {
    return MSetNXCommand<TData>(kv, opts).exec(_client);
  }

  /// @see https://redis.io/commands/persist
  Future<int> persist(String key, [CommandOption<dynamic, int>? opts]) {
    return PersistCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/pexpire
  Future<int> pexpire(
    String key,
    int milliseconds, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return PExpireCommand(key, milliseconds, opts).exec(_client);
  }

  /// @see https://redis.io/commands/pexpireat
  Future<int> pexpireat(
    String key,
    int unix, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return PExpireAtCommand(key, unix, opts).exec(_client);
  }

  /// @see https://redis.io/commands/ping
  Future<String> ping([String? message, CommandOption<String, String>? opts]) {
    return PingCommand(message, opts).exec(_client);
  }

  /// @see https://redis.io/commands/psetex
  Future<String> psetex<TData>(
    String key,
    int ttl,
    TData value, {
    CommandOption<String, String>? opts,
  }) {
    return PSetEXCommand<TData>(key, ttl, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/pttl
  Future<int> pttl(String key, [CommandOption<int, int>? opts]) {
    return PTtlCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/publish
  Future<int> publish<TData>(
    String channel,
    TData message, [
    CommandOption<int, int>? opts,
  ]) {
    return PublishCommand<TData>(channel, message, opts).exec(_client);
  }

  /// @see https://redis.io/commands/randomkey
  Future<String?> randomkey([CommandOption<String?, String?>? opts]) {
    return RandomKeyCommand(opts).exec(_client);
  }

  /// @see https://redis.io/commands/rename
  Future<String> rename(
    String source,
    String destination, [
    CommandOption<String, String>? opts,
  ]) {
    return RenameCommand(source, destination, opts).exec(_client);
  }

  /// @see https://redis.io/commands/renamenx
  Future<int> renamenx(
    String source,
    String destination, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return RenameNXCommand(source, destination, opts).exec(_client);
  }

  /// @see https://redis.io/commands/rpop
  Future<TData?> rpop<TData>(
    String key, [
    CommandOption<Object?, TData?>? opts,
  ]) {
    return RPopCommand<TData>(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/rpush
  Future<int> rpush<TData>(
    String key,
    List<TData> elements, [
    CommandOption<int, int>? opts,
  ]) {
    return RPushCommand<TData>(key, elements, opts).exec(_client);
  }

  /// @see https://redis.io/commands/rpushx
  Future<int> rpushx<TData>(
    String key,
    List<TData> elements, [
    CommandOption<int, int>? opts,
  ]) {
    return RPushXCommand<TData>(key, elements, opts).exec(_client);
  }

  /// @see https://redis.io/commands/sadd
  Future<int> sadd<TData>(
    String key,
    List<TData> members, [
    CommandOption<int, int>? opts,
  ]) {
    return SAddCommand<TData>(key, members, opts).exec(_client);
  }

  /// @see https://redis.io/commands/scan
  Future<List<dynamic>> scan(
    int cursor, {
    String? match,
    int? count,
    String? type,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    return ScanCommand(
      cursor,
      match: match,
      count: count,
      opts: opts,
      type: type,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/scard
  Future<int> scard(String key, [CommandOption<int, int>? opts]) {
    return SCardCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/script-exists
  Future<List<int>> scriptExists(
    List<String> hashes, [
    CommandOption<List<int>, List<int>>? opts,
  ]) {
    return ScriptExistsCommand(hashes, opts).exec(_client);
  }

  /// @see https://redis.io/commands/script-flush
  Future<String> scriptFlush({
    bool? sync,
    bool? async,
    CommandOption<String, String>? opts,
  }) {
    return ScriptFlushCommand(
      sync: sync,
      async: async,
      opts: opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/script-load
  Future<String> scriptLoad(
    String script, [
    CommandOption<String, String>? opts,
  ]) {
    return ScriptLoadCommand(script, opts).exec(_client);
  }

  /// @see https://redis.io/commands/sdiff
  Future<List<TData>> sdiff<TData>(
    List<String> keys, [
    CommandOption<List<dynamic>, List<TData>>? opts,
  ]) {
    return SDiffCommand<TData>(keys, opts).exec(_client);
  }

  /// @see https://redis.io/commands/sdiffstore
  Future<int> sdiffstore(List<String> keys, [CommandOption<int, int>? opts]) {
    return SDiffStoreCommand(keys, opts).exec(_client);
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
  Future<int> setbit(
    String key,
    int offset,
    int bit, [
    CommandOption<int, int>? opts,
  ]) {
    return SetBitCommand(key, offset, bit, opts).exec(_client);
  }

  /// @see https://redis.io/commands/setex
  Future<String> setex<TData>(
    String key,
    int ttl,
    TData value, [
    CommandOption<String, String>? opts,
  ]) {
    return SetExCommand<TData>(key, ttl, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/setnx
  Future<int> setnx<TData extends String>(
    String key,
    TData value, [
    CommandOption<int, int>? opts,
  ]) {
    return SetNxCommand<TData>(key, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/setrange
  Future<int> setrange(
    String key,
    int offset,
    String value, [
    CommandOption<int, int>? opts,
  ]) {
    return SetRangeCommand(key, offset, value, opts).exec(_client);
  }

  /// @see https://redis.io/commands/sinter
  Future<List<TData>> sinter<TData>(
    List<String> keys, [
    CommandOption<List<dynamic>, List<TData>>? opts,
  ]) {
    return SInterCommand<TData>(keys, opts).exec(_client);
  }

  /// @see https://redis.io/commands/sinterstore
  Future<int> sinterstore(
    String destination,
    List<String> keys, [
    CommandOption<int, int>? opts,
  ]) {
    return SInterStoreCommand(destination, keys, opts).exec(_client);
  }

  /// @see https://redis.io/commands/sismember
  Future<int> sismember<TData>(
    String key,
    TData member, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return SIsMemberCommand<TData>(key, member, opts).exec(_client);
  }

  /// @see https://redis.io/commands/sinter
  Future<List<TData>> smembers<TData>(
    String key, [
    CommandOption<List<dynamic>, List<TData>>? opts,
  ]) {
    return SMembersCommand<TData>(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/smove
  Future<int> smove<TData>(
    String source,
    String destination,
    TData member, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return SMoveCommand<TData>(source, destination, member).exec(_client);
  }

  /// @see https://redis.io/commands/spop
  Future<TData?> spop<TData>(
    String key, [
    int? count,
    CommandOption<dynamic, TData?>? opts,
  ]) {
    return SPopCommand<TData>(key, count, opts).exec(_client);
  }

  /// @see https://redis.io/commands/srandmember
  Future<TData?> srandmember<TData>(
    String key, [
    int? count,
    CommandOption<dynamic, TData?>? opts,
  ]) {
    return SRandMemberCommand<TData>(key, count, opts).exec(_client);
  }

  /// @see https://redis.io/commands/srem
  Future<int> srem<TData>(
    String key,
    List<TData> members, [
    CommandOption<int, int>? opts,
  ]) {
    return SRemCommand<TData>(key, members, opts).exec(_client);
  }

  /// @see https://redis.io/commands/sscan
  Future<List<dynamic>> sscan(
    String key,
    int cursor, {
    String? match,
    int? count,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    return SScanCommand(
      key,
      cursor,
      match: match,
      count: count,
      opts: opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/strlen
  Future<int> strlen(String key, [CommandOption<int, int>? opts]) {
    return StrLenCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/sunion
  Future<List<TData>> sunion<TData>(
    List<String> keys, [
    CommandOption<List<String>, List<TData>>? opts,
  ]) {
    return SUnionCommand<TData>(keys, opts).exec(_client);
  }

  /// @see https://redis.io/commands/sunionstore
  Future<int> sunionstore(
    String destination,
    List<String> keys, [
    CommandOption<int, int>? opts,
  ]) {
    return SUnionStoreCommand(destination, keys, opts).exec(_client);
  }

  /// @see https://redis.io/commands/time
  Future<List<int>> time([CommandOption<List<String>, List<int>>? opts]) {
    return TimeCommand(opts).exec(_client);
  }

  /// @see https://redis.io/commands/touch
  Future<int> touch(List<String> keys, [CommandOption<int, int>? opts]) {
    return TouchCommand(keys, opts).exec(_client);
  }

  /// @see https://redis.io/commands/ttl
  Future<int> ttl(String key, [CommandOption<int, int>? opts]) {
    return TtlCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/type
  Future<ValueType> type(String key, [CommandOption<String, ValueType>? opts]) {
    return TypeCommand(key).exec(_client);
  }

  /// @see https://redis.io/commands/unlink
  Future<int> unlink(List<String> keys, [CommandOption<int, int>? opts]) {
    return UnlinkCommand(keys, opts).exec(_client);
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
    CommandOption<dynamic, num?>? cmdOpts,
  }) {
    final allScores = [...scores];
    if (score != null && member != null) {
      allScores.insert(0, ScoreMember(score: score, member: member));
    }

    return ZAddCommand<TData>(
      key,
      allScores,
      ch: ch,
      incr: incr,
      nx: nx,
      xx: xx,
      cmdOpts: cmdOpts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/zcard
  Future<int> zcard(String key, [CommandOption<int, int>? opts]) {
    return ZCardCommand(key, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zcount
  Future<int> zcount(
    String key,
    Object min,
    Object max, [
    CommandOption<int, int>? opts,
  ]) {
    return ZCountCommand(key, min, max, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zincrby
  Future<num> zincrby<TData>(
    String key,
    num increment,
    TData member, [
    CommandOption<String, num>? opts,
  ]) {
    return ZIncrByCommand<TData>(key, increment, member, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zinterstore
  Future<num> zinterstore(
    String destination,
    int numKeys,
    List<String> keys, {
    AggregateType? aggregate,
    int? weight,
    List<int>? weights,
    CommandOption<int, int>? opts,
  }) {
    return ZInterStoreCommand(
      destination,
      numKeys,
      keys,
      aggregate: aggregate,
      weight: weight,
      weights: weights,
      opts: opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/zlexcount
  Future<int> zlexcount(
    String key,
    String min,
    String max, [
    CommandOption<int, int>? opts,
  ]) {
    return ZLexCountCommand(key, min, max, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zpopmax
  Future<List<TData>> zpopmax<TData>(
    String key, {
    int? count,
    CommandOption<List<String>, List<TData>>? opts,
  }) {
    return ZPopMaxCommand<TData>(key, count: count, opts: opts).exec(_client);
  }

  /// @see https://redis.io/commands/zpopmin
  Future<List<TData>> zpopmin<TData>(
    String key, {
    int? count,
    CommandOption<List<String>, List<TData>>? opts,
  }) {
    return ZPopMinCommand<TData>(key, count: count, opts: opts).exec(_client);
  }

  /// @see https://redis.io/commands/zrange
  Future<List<TData>> zrange<TData>(
    String key,
    Object min,
    Object max, {
    bool? withScores,
    bool? rev,
    bool? byScore,
    bool? byLex,
    int? offset,
    int? count,
    CommandOption<List<String?>, List<TData>>? opts,
  }) {
    return ZRangeCommand<TData>(
      key,
      min,
      max,
      withScores: withScores,
      rev: rev,
      byScore: byScore,
      byLex: byLex,
      offset: offset,
      count: count,
      opts: opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/zrank
  Future<int?> zrank<TData>(
    String key,
    TData member, [
    CommandOption<int?, int?>? opts,
  ]) {
    return ZRankCommand<TData>(key, member, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zrem
  Future<int> zrem<TData>(
    String key,
    List<TData> members, [
    CommandOption<int, int>? opts,
  ]) {
    return ZRemCommand<TData>(key, members, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zremrangebylex
  Future<int> zremrangebylex(
    String key,
    String min,
    String max, [
    CommandOption<int, int>? opts,
  ]) {
    return ZRemRangeByLexCommand(key, min, max, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zremrangebyrank
  Future<int> zremrangebyrank(
    String key,
    int start,
    int stop, [
    CommandOption<int, int>? opts,
  ]) {
    return ZRemRangeByRankCommand(key, start, stop, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zremrangebyscore
  Future<int> zremrangebyscore(
    String key,
    int min,
    int max, [
    CommandOption<int, int>? opts,
  ]) {
    return ZRemRangeByScoreCommand(key, min, max, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zrevrank
  Future<int?> zrevrank<TData>(
    String key,
    TData member, [
    CommandOption<int?, int?>? opts,
  ]) {
    return ZRevRankCommand<TData>(key, member, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zscan
  Future<List<dynamic>> zscan(
    String key,
    int cursor, {
    String? match,
    int? count,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    return ZScanCommand(
      key,
      cursor,
      match: match,
      count: count,
      opts: opts,
    ).exec(_client);
  }

  /// @see https://redis.io/commands/zscore
  Future<num?> zscore<TData>(
    String key,
    TData member, [
    CommandOption<String, num>? opts,
  ]) {
    return ZScoreCommand<TData>(key, member, opts).exec(_client);
  }

  /// @see https://redis.io/commands/zunionstore
  Future<num> zunionstore(
    String destination,
    int numKeys,
    List<String> keys, {
    AggregateType? aggregate,
    int? weight,
    List<int>? weights,
    CommandOption<int, int>? opts,
  }) {
    return ZUnionStoreCommand(
      destination,
      numKeys,
      keys,
      aggregate: aggregate,
      weight: weight,
      weights: weights,
      opts: opts,
    ).exec(_client);
  }
}
