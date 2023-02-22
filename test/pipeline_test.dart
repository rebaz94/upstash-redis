import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/mod.dart';
import 'package:upstash_redis/src/pipeline.dart';
import 'package:upstash_redis/src/redis.dart';
import 'package:upstash_redis/src/test_utils.dart';
import 'package:upstash_redis/src/upstash_error.dart';

void main() {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('with destructuring, correctly binds this', () async {
    final pipeline = Redis.byClient(client).pipeline;
    final p = pipeline();

    final echo = p.echo;
    final exec = p.exec;

    echo('Hello');

    final res = await exec();
    expect(res, ['Hello']);
  });

  test('with single command, works with multiple commands', () async {
    final p = Pipeline(client: client);
    p.set(newKey(), randomID());
    final res = await p.exec();
    expect(res.length, 1);
    expect(res[0], 'OK');
  });

  test('when chaining in a for loop, works', () async {
    final key = newKey();
    final value = 1;
    final res =
        await Pipeline(client: client).set(key, value).get<int>(key).exec();
    expect(res.length, 2);
    expect(res[0], 'OK');
    expect(res[1], value);
  });

  test('when chaining inline, works', () async {
    final key = newKey();
    final p = Pipeline(client: client);
    for (int i = 0; i < 10; i++) {
      p.set(key, randomID());
    }

    final res = await p.exec();
    expect(res.length, 10);
    expect(res, List.generate(10, (index) => 'OK'));
  });

  test('when no commands were added, throws', () async {
    expectLater(Pipeline(client: client).exec(), throwsStateError);
  });

  group('when one command throws', () {
    test('throws', () async {
      final p =
          Pipeline(client: client).set('key', 'value').hget('key', 'field');
      expectLater(p.exec(), throwsException);
    });

    test('if throwsIfHasAnyCommandError is false, returns result and error',
        () async {
      final p = Pipeline(client: client)
          .hincrby('myHash', 'count', 1)
          .set('key2', 'value')
          .hget('key2', 'field');
      final res = await p.exec(throwsIfHasAnyCommandError: false);
      expect(res.length, 3);
      expect(res[0], 1);
      expect(res[1], 'OK');
      expect(res[2], isA<UpstashError>());
    });
  });

  test('transaction, works', () async {
    final key = newKey();
    final value = randomID();
    final tx = Pipeline(client: client, multiExec: true);
    tx.set(key, value);
    tx.get<String>(key);
    tx.del([key]);

    final result = await tx.exec();
    expect(result.first, 'OK');
    expect(result[1], value);
    expect(result.last, 1);
  });

  test('convert result to model works', () async {
    final p = Pipeline(client: client)
        .set('name', 'rebaz')
        .set('age', 27)
        .get('name')
        .get<int>('age');
    final res = await p.execWithModel(MyModel.fromResult,
        throwsIfHasAnyCommandError: false);
    expect(res.name, 'rebaz');
    expect(res.age, 27);
  });

  test('use all the things, works', () async {
    final p = Pipeline(client: client);
    final persistentKey = newKey();
    final persistentKey2 = newKey();

    final scriptHash = await ScriptLoadCommand('return 1').exec(client);

    p
        .append(newKey(), 'hello')
        .bitcount(newKey(), start: 0, end: 1)
        .bitop(BitOp.and, newKey(), [newKey()])
        .bitpos(newKey(), 0, 1)
        .dbsize()
        .decr(newKey())
        .decrby(newKey(), 1)
        .del([newKey()])
        .echo('hello')
        .eval('return ARGV[1]', [], ['Hello'])
        .evalsha(scriptHash, [], ['Hello'])
        .exists([newKey()])
        .expire(newKey(), 5)
        .expireat(
            newKey(), (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 60)
        .flushall()
        .flushdb()
        .get(newKey())
        .getbit(newKey(), 0)
        .getdel(newKey())
        .getrange(newKey(), 0, 1)
        .getset(newKey(), 'hello')
        .hdel(newKey(), 'field')
        .hexists(newKey(), 'field')
        .hget(newKey(), 'field')
        .hgetall(newKey())
        .hincrby(newKey(), 'field', 1)
        .hincrbyfloat(newKey(), 'field', 1.5)
        .hkeys(newKey())
        .hlen(newKey())
        .hmget<String>(newKey(), [newKey()])
        .hmset(newKey(), {'field': 'field', 'value': 'value'})
        .hscan(newKey(), 0)
        .hset('hsetExample', {'field': 123})
        .hget<int>('hsetExample', 'field')
        .hsetnx(newKey(), 'field', 'value')
        .hstrlen(newKey(), 'field')
        .hvals(newKey())
        .incr(newKey())
        .incrby(newKey(), 1)
        .incrbyfloat(newKey(), 1.5)
        .keys('*')
        .lindex(newKey(), 0)
        .linsert(newKey(), IDirection.before, 'pivot', 'value')
        .llen(newKey())
        .lmove(newKey(), newKey(),
            whereFrom: LMoveDir.left, whereTo: LMoveDir.right)
        .lpop(newKey())
        .lpos(newKey(), 'value')
        .lpush(persistentKey, ['element'])
        .lpushx(newKey(), ['element1', 'element2'])
        .lrange(newKey(), 0, 1)
        .lrem(newKey(), 1, 'value')
        .lset(persistentKey, 0, 'value')
        .ltrim(newKey(), 0, 1)
        .hrandfield(newKey())
        .hrandfield(newKey(), count: 2)
        .hrandfield(newKey(), count: 3, withValues: true)
        .mget<String>([newKey(), newKey()])
        .mset({'key1': 'value', 'key2': 'value'})
        .msetnx({'key3': 'value', 'key4': 'value'})
        .persist(newKey())
        .pexpire(newKey(), 1000)
        .pexpireat(newKey(), DateTime.now().millisecondsSinceEpoch + 1000)
        .ping()
        .psetex(newKey(), 1, 'value')
        .pttl(newKey())
        .publish('test', 'hello')
        .randomkey()
        .rename(persistentKey, persistentKey2)
        .renamenx(persistentKey2, newKey())
        .rpop(newKey())
        .rpush(newKey(), ['element1', 'element2'])
        .rpushx(newKey(), ['element1', 'element2'])
        .sadd(newKey(), ['memeber1', 'member2'])
        .scan(0)
        .scard(newKey())
        .sdiff([newKey()])
        .sdiffstore([newKey(), newKey()])
        .set(newKey(), 'value')
        .setbit(newKey(), 1, 1)
        .setex(newKey(), 1, 'value')
        .setnx(newKey(), 'value')
        .setrange(newKey(), 1, 'value')
        .sinter([newKey(), newKey()])
        .sinterstore(newKey(), [newKey()])
        .sismember(newKey(), 'member')
        .smembers(newKey())
        .smove(newKey(), newKey(), 'member')
        .spop(newKey())
        .srandmember(newKey())
        .srem(newKey(), ['member'])
        .sscan(newKey(), 0)
        .strlen(newKey())
        .sunion([newKey()])
        .sunionstore(newKey(), [newKey()])
        .time()
        .touch([newKey()])
        .ttl(newKey())
        .type(newKey())
        .unlink([])
        .zadd(newKey(), score: 0, member: 'member')
        .zcard(newKey())
        .scriptExists([scriptHash])
        .scriptFlush(async: true)
        .scriptLoad('return 1')
        .zcount(newKey(), 0, 1)
        .zincrby(newKey(), 1, 'member')
        .zinterstore(newKey(), 1, [newKey()])
        .zlexcount(newKey(), '-', '+')
        .zpopmax(newKey())
        .zpopmin(newKey())
        .zrange(newKey(), 0, 1)
        .zrank(newKey(), 'member')
        .zrem(newKey(), ['member'])
        .zremrangebylex(newKey(), '-', '+')
        .zremrangebyrank(newKey(), 0, 1)
        .zremrangebyscore(newKey(), 0, 1)
        .zrevrank(newKey(), 'member')
        .zscan(newKey(), 0)
        .zscore(newKey(), 'member')
        .zunionstore(newKey(), 1, [newKey()]);

    final res = await p.exec();
    expect(res.length, 120);
  });
}

class MyModel {
  const MyModel({
    required this.name,
    required this.age,
  });

  factory MyModel.fromResult(List<dynamic> result) {
    return MyModel(
      name: result[2] as String,
      age: result[3] as int,
    );
  }

  final String name;
  final int age;

  @override
  String toString() {
    return 'MyModel{name: $name, age: $age}';
  }
}
