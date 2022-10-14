import 'package:upstash_redis/src/upstash_error.dart';

import 'commands/mod.dart';

/// Upstash REST API supports command pipelining to send multiple commands in
/// batch, instead of sending each command one by one and waiting for a response.
/// When using pipelines, several commands are sent using a single HTTP request,
/// and a single JSON array response is returned. Each item in the response array
/// corresponds to the command in the same order within the pipeline.
///
/// **NOTE:**
///
/// Execution of the pipeline is not atomic. Even though each command in
/// the pipeline will be executed in order, commands sent by other clients can
/// interleave with the pipeline.
///
/// **Examples:**
///
/// ```dart
///  final p = redis.pipeline();
///  p.set("key","value");
///  p.get("key");
///  final res = await p.exec();
/// ```
///
/// You can also chain commands together
/// ```dart
/// final p = redis.pipeline();
/// final res = await p.set("key","value").get("key").exec();
/// ```
///
/// It's not possible to infer correct types with a dynamic pipeline, so you can
/// provide the custom callback to create your own model from the list of response:
/// ```dart
///  redis.pipeline()
///   .set("key", { greeting: "hello"})
///   .get("key")
///   .execWith<Model>((listResult) => Model.fromRPipeline(listResult))
///
/// ```
class Pipeline {
  Pipeline(Requester client)
      : _client = client,
        _commands = [];

  final Requester _client;
  final List<Command<dynamic, dynamic>> _commands;

  /// Send the pipeline request to upstash.
  ///
  /// Returns an array with the results of all pipelined commands.
  ///
  /// if [throwsIfHasAnyCommandError] is false, failed commands error will be
  /// added to the result instead of throwing the error
  ///
  /// see [execWithModel] if you want to create a model from the list of the command result
  Future<List<dynamic>> exec({bool throwsIfHasAnyCommandError = true}) async {
    if (_commands.isEmpty) {
      throw StateError('Pipeline is empty');
    }

    final responses = await _client.requestPipeline(
      path: ['pipeline'],
      body: _commands.map((e) => e.command).toList(),
      commands: _commands,
    );

    final result = [];
    int i = 0;
    for (final cmdResult in responses) {
      if (cmdResult.error != null) {
        final error = UpstashError(
          'Command ${i + 1} [ ${_commands[i].command[0]} ] failed: ${cmdResult.error}',
        );
        if (throwsIfHasAnyCommandError) {
          throw error;
        } else {
          result.add(error);
        }
      } else {
        result.add(_commands[i].decodeValueFrom(cmdResult.result));
      }
      i++;
    }

    return result;
  }

  /// Send the pipeline request to upstash.
  ///
  /// Returns a [T] result model, created using [create] callback.
  ///
  /// if [throwsIfHasAnyCommandError] is false, failed commands error will be
  /// added to the result instead of throwing the error
  Future<T> execWithModel<T>(
    T Function(List<dynamic> result) create, {
    bool throwsIfHasAnyCommandError = true,
  }) async {
    final result = await exec(
      throwsIfHasAnyCommandError: throwsIfHasAnyCommandError,
    );
    return create(result);
  }

  /// Pushes a command into the pipeline and returns a chainable instance of the pipeline
  Pipeline _chain<T>(Command<dynamic, T> command) {
    _commands.add(command);
    return this;
  }

  /// @see https://redis.io/commands/append
  Pipeline append(String key, String value, [CommandOption<int, int>? opts]) {
    return _chain(AppendCommand(key, value));
  }

  /// @see https://redis.io/commands/bitcount
  Pipeline bitcount(String key,
      {int? start, int? end, CommandOption<int, int>? opts}) {
    return _chain(BitCountCommand(key, start: start, end: end, opts: opts));
  }

  /// @see https://redis.io/commands/bitop
  Pipeline bitop(
    BitOp op,
    String destinationKey,
    List<String> sourceKeys, [
    CommandOption<int, int>? opts,
  ]) {
    return _chain(BitOpCommand(op, destinationKey, sourceKeys, opts));
  }

  /// @see https://redis.io/commands/bitpos
  Pipeline bitpos(String key, int bit,
      [int? start, int? end, CommandOption<int, int>? opts]) {
    return _chain(BitPosCommand(key, bit, start, end, opts));
  }

  /// @see https://redis.io/commands/dbsize
  Pipeline dbsize([CommandOption<int, int>? opts]) {
    return _chain(DbSizeCommand(opts));
  }

  /// @see https://redis.io/commands/decr
  Pipeline decr(String key, [CommandOption<int, int>? opts]) {
    return _chain(DecrCommand(key, opts));
  }

  /// @see https://redis.io/commands/decrby
  Pipeline decrby(String key, int decrement, [CommandOption<int, int>? opts]) {
    return _chain(DecrByCommand(key, decrement, opts));
  }

  /// @see https://redis.io/commands/del
  Pipeline del(List<String> keys, [CommandOption<int, int>? opts]) {
    return _chain(DelCommand(keys, opts));
  }

  /// @see https://redis.io/commands/echo
  Pipeline echo(String message, [CommandOption<String, String>? opts]) {
    return _chain(EchoCommand(message, opts));
  }

  /// @see https://redis.io/commands/eval
  Pipeline eval<TArgs, TData>(
    String script,
    List<String> keys,
    List<TArgs> args, [
    CommandOption<dynamic, TData>? opts,
  ]) {
    return _chain(EvalCommand<TArgs, TData>(script, keys, args, opts));
  }

  /// @see https://redis.io/commands/evalsha
  Pipeline evalsha<TArgs, TData>(
    String sha,
    List<String> keys,
    List<TArgs> args, [
    CommandOption<dynamic, TData>? opts,
  ]) {
    return _chain(EvalshaCommand<TArgs, TData>(sha, keys, args, opts));
  }

  /// @see https://redis.io/commands/exists
  Pipeline exists(List<String> keys, [CommandOption<int, int>? opts]) {
    return _chain(ExistsCommand(keys));
  }

  /// @see https://redis.io/commands/expire
  Pipeline expire(String key, int seconds, [CommandOption<int, int>? opts]) {
    return _chain(ExpireCommand(key, seconds, opts));
  }

  /// @see https://redis.io/commands/expireat
  Pipeline expireat(String key, int unix, [CommandOption<int, int>? opts]) {
    return _chain(ExpireCommand(key, unix, opts));
  }

  /// @see https://redis.io/commands/flushall
  Pipeline flushall({bool? async, CommandOption<String, String>? opts}) {
    return _chain(FlushAllCommand(async: async, opts: opts));
  }

  /// @see https://redis.io/commands/flushdb
  Pipeline flushdb({bool? async, CommandOption<String, String>? opts}) {
    return _chain(FlushDbCommand(async: async, opts: opts));
  }

  /// @see https://redis.io/commands/get
  Pipeline get<TData>(String key, [CommandOption<dynamic, TData>? opts]) {
    return _chain(GetCommand<TData>(key, opts));
  }

  /// @see https://redis.io/commands/getbit
  Pipeline getbit(String key, int offset, [CommandOption<int, int>? opts]) {
    return _chain(GetBitCommand(key, offset, opts));
  }

  /// @see https://redis.io/commands/getrange
  Pipeline getrange(String key, int start, int end,
      [CommandOption<String, String>? opts]) {
    return _chain(GetRangeCommand(key, start, end, opts));
  }

  /// @see https://redis.io/commands/getset
  Pipeline getset<TData>(String key, TData value,
      [CommandOption<dynamic, TData>? opts]) {
    return _chain(GetSetCommand<TData>(key, value, opts));
  }

  /// @see https://redis.io/commands/hget
  Pipeline hget<TData>(String key, String field,
      [CommandOption<dynamic, TData?>? opts]) {
    return _chain(HGetCommand<TData>(key, field, opts));
  }

  /// @see https://redis.io/commands/hgetall
  Pipeline hgetall<TData>(String key,
      [CommandOption<dynamic, Map<String, TData?>>? opts]) {
    return _chain(HGetAllCommand<TData>(key, opts));
  }

  /// @see https://redis.io/commands/hincrby
  Pipeline hincrby(
    String key,
    String field,
    int increment, [
    CommandOption<int, int>? opts,
  ]) {
    return _chain(HIncrByCommand(key, field, increment, opts));
  }

  /// @see https://redis.io/commands/hincrbyfloat
  Pipeline hincrbyfloat(
    String key,
    String field,
    num increment, [
    CommandOption<num, num>? opts,
  ]) {
    return _chain(HIncrByFloatCommand(key, field, increment, opts));
  }

  /// @see https://redis.io/commands/hkeys
  Pipeline hkeys(String key,
      [CommandOption<List<String>, List<String>>? opts]) {
    return _chain(HKeysCommand(key, opts));
  }

  /// @see https://redis.io/commands/hlen
  Pipeline hlen(String key, [CommandOption<List<String>, List<String>>? opts]) {
    return _chain(HKeysCommand(key, opts));
  }

  /// @see https://redis.io/commands/hmget
  Pipeline hmget<TData>(
    String key,
    List<String> fields, [
    CommandOption<List<dynamic>, Map<String, TData?>>? opts,
  ]) {
    return _chain(HMGetCommand<TData>(key, fields, opts));
  }

  /// @see https://redis.io/commands/hmset
  Pipeline hmset<TData>(String key, Map<String, TData> kv,
      [CommandOption<String, String>? opts]) {
    return _chain(HMSetCommand<TData>(key, kv, opts));
  }

  /// @see https://redis.io/commands/hscan
  Pipeline hscan(
    String key,
    int cursor, {
    String? match,
    int? count,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    return _chain(HScanCommand(
      key,
      cursor,
      match: match,
      count: count,
      opts: opts,
    ));
  }

  /// @see https://redis.io/commands/hdel
  Pipeline hdel(String key, String field, [CommandOption<int, int>? opts]) {
    return _chain(HDelCommand(key, field, opts));
  }

  /// @see https://redis.io/commands/hexists
  Pipeline hexists(String key, String field, [CommandOption<int, int>? opts]) {
    return _chain(HExistsCommand(key, field, opts));
  }

  /// @see https://redis.io/commands/hset
  Pipeline hset<TData>(String key, Map<String, TData> kv,
      [CommandOption<int, int>? opts]) {
    return _chain(HSetCommand<TData>(key, kv, opts));
  }

  /// @see https://redis.io/commands/hsetnx
  Pipeline hsetnx<TData>(String key, String field, TData value,
      [CommandOption<int, int>? opts]) {
    return _chain(HSetNXCommand<TData>(key, field, value, opts));
  }

  /// @see https://redis.io/commands/hstrlen
  Pipeline hstrlen(String key, String field, [CommandOption<int, int>? opts]) {
    return _chain(HStrLenCommand(key, field, opts));
  }

  /// @see https://redis.io/commands/hvals
  Pipeline hvals<TData>(String key,
      [CommandOption<List<TData>, List<TData>>? opts]) {
    return _chain(HValsCommand<TData>(key, opts));
  }

  /// @see https://redis.io/commands/incr
  Pipeline incr(String key, [CommandOption<int, int>? opts]) {
    return _chain(IncrCommand(key, opts));
  }

  /// @see https://redis.io/commands/incrby
  Pipeline incrby(String key, int value, [CommandOption<int, int>? opts]) {
    return _chain(IncrByCommand(key, value, opts));
  }

  /// @see https://redis.io/commands/incrbyfloat
  Pipeline incrbyfloat(String key, num value, [CommandOption<num, num>? opts]) {
    return _chain(IncrByFloatCommand(key, value, opts));
  }

  /// @see https://redis.io/commands/keys
  Pipeline keys(String pattern,
      [CommandOption<List<String>, List<String>>? opts]) {
    return _chain(KeysCommand(pattern, opts));
  }

  /// @see https://redis.io/commands/lindex
  Pipeline lindex<TData>(String key, int index,
      [CommandOption<Object?, TData?>? opts]) {
    return _chain(LIndexCommand<TData>(key, index, opts));
  }

  /// @see https://redis.io/commands/linsert
  Pipeline linsert<TData>(
    String key,
    IDirection direction,
    TData pivot,
    TData value, [
    CommandOption<int, int>? opts,
  ]) {
    return _chain(LInsertCommand<TData>(key, direction, pivot, value, opts));
  }

  /// @see https://redis.io/commands/llen
  Pipeline llen(String key, [CommandOption<int, int>? opts]) {
    return _chain(LLenCommand(key, opts));
  }

  /// @see https://redis.io/commands/lpop
  Pipeline lpop<TData>(String key, [CommandOption<Object?, TData?>? opts]) {
    return _chain(LPopCommand<TData>(key, opts));
  }

  /// @see https://redis.io/commands/lpos
  Pipeline lpos<TData>(
    String key,
    dynamic element, {
    int? rank,
    int? count,
    int? maxLen,
    CommandOption<TData, TData>? opts,
  }) {
    return _chain(LPosCommand<TData>(
      key,
      element,
      rank: rank,
      count: count,
      maxLen: maxLen,
      opts: opts,
    ));
  }

  /// @see https://redis.io/commands/lpush
  Pipeline lpush<TData>(String key, List<TData> elements,
      [CommandOption<int, int>? opts]) {
    return _chain(LPushCommand<TData>(key, elements, opts));
  }

  /// @see https://redis.io/commands/lpushx
  Pipeline lpushx<TData>(String key, List<TData> elements,
      [CommandOption<int, int>? opts]) {
    return _chain(LPushCommand<TData>(key, elements, opts));
  }

  /// @see https://redis.io/commands/lrange
  Pipeline lrange<TData>(
    String key,
    int start,
    int end, [
    CommandOption<List<String?>, List<TData>>? opts,
  ]) {
    return _chain(LRangeCommand<TData>(key, start, end, opts));
  }

  /// @see https://redis.io/commands/lrem
  Pipeline lrem<TData>(String key, int count, TData value,
      [CommandOption<int, int>? opts]) {
    return _chain(LRemCommand<TData>(key, count, value, opts));
  }

  /// @see https://redis.io/commands/lset
  Pipeline lset<TData>(
    String key,
    int index,
    TData value, [
    CommandOption<String, String>? opts,
  ]) {
    return _chain(LSetCommand<TData>(key, index, value, opts));
  }

  /// @see https://redis.io/commands/ltrim
  Pipeline ltrim(
    String key,
    int start,
    int end, [
    CommandOption<String, String>? opts,
  ]) {
    return _chain(LTrimCommand(key, start, end, opts));
  }

  /// @see https://redis.io/commands/mget
  Pipeline mget<TData>(
    List<String> keys, [
    CommandOption<List<String?>, List<TData?>>? opts,
  ]) {
    return _chain(MGetCommand<TData>(keys, opts));
  }

  /// @see https://redis.io/commands/mset
  Pipeline mset<TData>(Map<String, TData> kv,
      [CommandOption<String, String>? opts]) {
    return _chain(MSetCommand<TData>(kv, opts));
  }

  /// @see https://redis.io/commands/msetnx
  Pipeline msetnx<TData>(Map<String, TData> kv,
      [CommandOption<int, int>? opts]) {
    return _chain(MSetNXCommand<TData>(kv, opts));
  }

  /// @see https://redis.io/commands/persist
  Pipeline persist(String key, [CommandOption<dynamic, int>? opts]) {
    return _chain(PersistCommand(key, opts));
  }

  /// @see https://redis.io/commands/pexpire
  Pipeline pexpire(String key, int milliseconds,
      [CommandOption<dynamic, int>? opts]) {
    return _chain(PExpireCommand(key, milliseconds, opts));
  }

  /// @see https://redis.io/commands/pexpireat
  Pipeline pexpireat(String key, int unix,
      [CommandOption<dynamic, int>? opts]) {
    return _chain(PExpireAtCommand(key, unix, opts));
  }

  /// @see https://redis.io/commands/ping
  Pipeline ping([String? message, CommandOption<String, String>? opts]) {
    return _chain(PingCommand(message, opts));
  }

  /// @see https://redis.io/commands/psetex
  Pipeline psetex<TData>(
    String key,
    int ttl,
    TData value, {
    CommandOption<String, String>? opts,
  }) {
    return _chain(PSetEXCommand<TData>(key, ttl, value, opts));
  }

  /// @see https://redis.io/commands/pttl
  Pipeline pttl(String key, [CommandOption<int, int>? opts]) {
    return _chain(PTtlCommand(key, opts));
  }

  /// @see https://redis.io/commands/publish
  Pipeline publish<TData>(String channel, TData message,
      [CommandOption<int, int>? opts]) {
    return _chain(PublishCommand<TData>(channel, message, opts));
  }

  /// @see https://redis.io/commands/randomkey
  Pipeline randomkey([CommandOption<String?, String?>? opts]) {
    return _chain(RandomKeyCommand(opts));
  }

  /// @see https://redis.io/commands/rename
  Pipeline rename(String source, String destination,
      [CommandOption<String, String>? opts]) {
    return _chain(RenameCommand(source, destination, opts));
  }

  /// @see https://redis.io/commands/renamenx
  Pipeline renamenx(String source, String destination,
      [CommandOption<dynamic, int>? opts]) {
    return _chain(RenameNXCommand(source, destination, opts));
  }

  /// @see https://redis.io/commands/rpop
  Pipeline rpop<TData>(String key, [CommandOption<Object?, TData?>? opts]) {
    return _chain(RPopCommand<TData>(key, opts));
  }

  /// @see https://redis.io/commands/rpush
  Pipeline rpush<TData>(String key, List<TData> elements,
      [CommandOption<int, int>? opts]) {
    return _chain(RPushCommand<TData>(key, elements, opts));
  }

  /// @see https://redis.io/commands/rpushx
  Pipeline rpushx<TData>(String key, List<TData> elements,
      [CommandOption<int, int>? opts]) {
    return _chain(RPushXCommand<TData>(key, elements, opts));
  }

  /// @see https://redis.io/commands/sadd
  Pipeline sadd<TData>(String key, List<TData> members,
      [CommandOption<int, int>? opts]) {
    return _chain(SAddCommand<TData>(key, members, opts));
  }

  /// @see https://redis.io/commands/scan
  Pipeline scan(
    int cursor, {
    String? match,
    int? count,
    String? type,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    return _chain(ScanCommand(cursor,
        match: match, count: count, opts: opts, type: type));
  }

  /// @see https://redis.io/commands/scard
  Pipeline scard(String key, [CommandOption<int, int>? opts]) {
    return _chain(SCardCommand(key, opts));
  }

  /// @see https://redis.io/commands/script-exists
  Pipeline scriptExists(List<String> hashes,
      [CommandOption<List<int>, List<int>>? opts]) {
    return _chain(ScriptExistsCommand(hashes, opts));
  }

  /// @see https://redis.io/commands/script-flush
  Pipeline scriptFlush(
      {bool? sync, bool? async, CommandOption<String, String>? opts}) {
    return _chain(ScriptFlushCommand(sync: sync, async: async, opts: opts));
  }

  /// @see https://redis.io/commands/script-load
  Pipeline scriptLoad(String script, [CommandOption<String, String>? opts]) {
    return _chain(ScriptLoadCommand(script, opts));
  }

  /// @see https://redis.io/commands/sdiff
  Pipeline sdiff<TData>(
    List<String> keys, [
    CommandOption<List<dynamic>, List<TData>>? opts,
  ]) {
    return _chain(SDiffCommand<TData>(keys, opts));
  }

  /// @see https://redis.io/commands/sdiffstore
  Pipeline sdiffstore(List<String> keys, [CommandOption<int, int>? opts]) {
    return _chain(SDiffStoreCommand(keys, opts));
  }

  /// @see https://redis.io/commands/set
  Pipeline set<TData>(
    String key,
    TData value, {
    int? ex,
    int? px,
    bool? nx,
    bool? xx,
    CommandOption<String, String>? opts,
  }) {
    return _chain(SetCommand<TData, String>(
      key,
      value,
      ex: ex,
      px: px,
      nx: nx,
      xx: xx,
      opts: opts,
    ));
  }

  /// @see https://redis.io/commands/setbit
  Pipeline setbit(String key, int offset, int bit,
      [CommandOption<int, int>? opts]) {
    return _chain(SetBitCommand(key, offset, bit, opts));
  }

  /// @see https://redis.io/commands/setex
  Pipeline setex<TData>(
    String key,
    int ttl,
    TData value, [
    CommandOption<String, String>? opts,
  ]) {
    return _chain(SetExCommand<TData>(key, ttl, value, opts));
  }

  /// @see https://redis.io/commands/setnx
  Pipeline setnx<TData extends String>(
    String key,
    TData value, [
    CommandOption<int, int>? opts,
  ]) {
    return _chain(SetNxCommand<TData>(key, value, opts));
  }

  /// @see https://redis.io/commands/setrange
  Pipeline setrange(String key, int offset, String value,
      [CommandOption<int, int>? opts]) {
    return _chain(SetRangeCommand(key, offset, value, opts));
  }

  /// @see https://redis.io/commands/sinter
  Pipeline sinter<TData>(
    List<String> keys, [
    CommandOption<List<dynamic>, List<TData>>? opts,
  ]) {
    return _chain(SInterCommand<TData>(keys, opts));
  }

  /// @see https://redis.io/commands/sinterstore
  Pipeline sinterstore(String destination, List<String> keys,
      [CommandOption<int, int>? opts]) {
    return _chain(SInterStoreCommand(destination, keys, opts));
  }

  /// @see https://redis.io/commands/sismember
  Pipeline sismember<TData>(String key, TData member,
      [CommandOption<dynamic, int>? opts]) {
    return _chain(SIsMemberCommand<TData>(key, member, opts));
  }

  /// @see https://redis.io/commands/sinter
  Pipeline smembers<TData>(
    String key, [
    CommandOption<List<dynamic>, List<TData>>? opts,
  ]) {
    return _chain(SMembersCommand<TData>(key, opts));
  }

  /// @see https://redis.io/commands/smove
  Pipeline smove<TData>(
    String source,
    String destination,
    TData member, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return _chain(SMoveCommand<TData>(source, destination, member));
  }

  /// @see https://redis.io/commands/spop
  Pipeline spop<TData>(
    String key, [
    int? count,
    CommandOption<dynamic, TData?>? opts,
  ]) {
    return _chain(SPopCommand<TData>(key, count, opts));
  }

  /// @see https://redis.io/commands/srandmember
  Pipeline srandmember<TData>(
    String key, [
    int? count,
    CommandOption<dynamic, TData?>? opts,
  ]) {
    return _chain(SRandMemberCommand<TData>(key, count, opts));
  }

  /// @see https://redis.io/commands/srem
  Pipeline srem<TData>(String key, List<TData> members,
      [CommandOption<int, int>? opts]) {
    return _chain(SRemCommand<TData>(key, members, opts));
  }

  /// @see https://redis.io/commands/sscan
  Pipeline sscan(
    String key,
    int cursor, {
    String? match,
    int? count,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    return _chain(
        SScanCommand(key, cursor, match: match, count: count, opts: opts));
  }

  /// @see https://redis.io/commands/strlen
  Pipeline strlen(String key, [CommandOption<int, int>? opts]) {
    return _chain(StrLenCommand(key, opts));
  }

  /// @see https://redis.io/commands/sunion
  Pipeline sunion<TData>(
    List<String> keys, [
    CommandOption<List<String>, List<TData>>? opts,
  ]) {
    return _chain(SUnionCommand<TData>(keys, opts));
  }

  /// @see https://redis.io/commands/sunionstore
  Pipeline sunionstore(String destination, List<String> keys,
      [CommandOption<int, int>? opts]) {
    return _chain(SUnionStoreCommand(destination, keys, opts));
  }

  /// @see https://redis.io/commands/time
  Pipeline time([CommandOption<List<String>, List<int>>? opts]) {
    return _chain(TimeCommand(opts));
  }

  /// @see https://redis.io/commands/touch
  Pipeline touch(List<String> keys, [CommandOption<int, int>? opts]) {
    return _chain(TouchCommand(keys, opts));
  }

  /// @see https://redis.io/commands/ttl
  Pipeline ttl(String key, [CommandOption<int, int>? opts]) {
    return _chain(TtlCommand(key, opts));
  }

  /// @see https://redis.io/commands/type
  Pipeline type(String key, [CommandOption<String, ValueType>? opts]) {
    return _chain(TypeCommand(key));
  }

  /// @see https://redis.io/commands/unlink
  Pipeline unlink(List<String> keys, [CommandOption<int, int>? opts]) {
    return _chain(UnlinkCommand(keys, opts));
  }

  /// @see https://redis.io/commands/zadd
  Pipeline zadd<TData>(
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

    return _chain(ZAddCommand<TData>(
      key,
      allScores,
      ch: ch,
      incr: incr,
      nx: nx,
      xx: xx,
      cmdOpts: cmdOpts,
    ));
  }

  /// @see https://redis.io/commands/zcard
  Pipeline zcard(String key, [CommandOption<int, int>? opts]) {
    return _chain(ZCardCommand(key, opts));
  }

  /// @see https://redis.io/commands/zcount
  Pipeline zcount(
    String key,
    Object min,
    Object max, [
    CommandOption<int, int>? opts,
  ]) {
    return _chain(ZCountCommand(key, min, max, opts));
  }

  /// @see https://redis.io/commands/zincrby
  Pipeline zincrby<TData>(
    String key,
    num increment,
    TData member, [
    CommandOption<String, num>? opts,
  ]) {
    return _chain(ZIncrByCommand<TData>(key, increment, member, opts));
  }

  /// @see https://redis.io/commands/zinterstore
  Pipeline zinterstore(
    String destination,
    int numKeys,
    List<String> keys, {
    AggregateType? aggregate,
    int? weight,
    List<int>? weights,
    CommandOption<int, int>? opts,
  }) {
    return _chain(ZInterStoreCommand(
      destination,
      numKeys,
      keys,
      aggregate: aggregate,
      weight: weight,
      weights: weights,
      opts: opts,
    ));
  }

  /// @see https://redis.io/commands/zlexcount
  Pipeline zlexcount(
    String key,
    String min,
    String max, [
    CommandOption<int, int>? opts,
  ]) {
    return _chain(ZLexCountCommand(key, min, max, opts));
  }

  /// @see https://redis.io/commands/zpopmax
  Pipeline zpopmax<TData>(
    String key, {
    int? count,
    CommandOption<List<String>, List<TData>>? opts,
  }) {
    return _chain(ZPopMaxCommand<TData>(key, count: count, opts: opts));
  }

  /// @see https://redis.io/commands/zpopmin
  Pipeline zpopmin<TData>(
    String key, {
    int? count,
    CommandOption<List<String>, List<TData>>? opts,
  }) {
    return _chain(ZPopMinCommand<TData>(key, count: count, opts: opts));
  }

  /// @see https://redis.io/commands/zrange
  Pipeline zrange<TData>(
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
    return _chain(ZRangeCommand<TData>(
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
    ));
  }

  /// @see https://redis.io/commands/zrank
  Pipeline zrank<TData>(String key, TData member,
      [CommandOption<int?, int?>? opts]) {
    return _chain(ZRankCommand<TData>(key, member, opts));
  }

  /// @see https://redis.io/commands/zrem
  Pipeline zrem<TData>(String key, List<TData> members,
      [CommandOption<int, int>? opts]) {
    return _chain(ZRemCommand<TData>(key, members, opts));
  }

  /// @see https://redis.io/commands/zremrangebylex
  Pipeline zremrangebylex(String key, String min, String max,
      [CommandOption<int, int>? opts]) {
    return _chain(ZRemRangeByLexCommand(key, min, max, opts));
  }

  /// @see https://redis.io/commands/zremrangebyrank
  Pipeline zremrangebyrank(String key, int start, int stop,
      [CommandOption<int, int>? opts]) {
    return _chain(ZRemRangeByRankCommand(key, start, stop, opts));
  }

  /// @see https://redis.io/commands/zremrangebyscore
  Pipeline zremrangebyscore(String key, int min, int max,
      [CommandOption<int, int>? opts]) {
    return _chain(ZRemRangeByScoreCommand(key, min, max, opts));
  }

  /// @see https://redis.io/commands/zrevrank
  Pipeline zrevrank<TData>(String key, TData member,
      [CommandOption<int?, int?>? opts]) {
    return _chain(ZRevRankCommand<TData>(key, member, opts));
  }

  /// @see https://redis.io/commands/zscan
  Pipeline zscan(
    String key,
    int cursor, {
    String? match,
    int? count,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    return _chain(
        ZScanCommand(key, cursor, match: match, count: count, opts: opts));
  }

  /// @see https://redis.io/commands/zscore
  Pipeline zscore<TData>(String key, TData member,
      [CommandOption<String, num>? opts]) {
    return _chain(ZScoreCommand<TData>(key, member, opts));
  }

  /// @see https://redis.io/commands/zunionstore
  Pipeline zunionstore(
    String destination,
    int numKeys,
    List<String> keys, {
    AggregateType? aggregate,
    int? weight,
    List<int>? weights,
    CommandOption<int, int>? opts,
  }) {
    return _chain(ZUnionStoreCommand(
      destination,
      numKeys,
      keys,
      aggregate: aggregate,
      weight: weight,
      weights: weights,
      opts: opts,
    ));
  }
}
