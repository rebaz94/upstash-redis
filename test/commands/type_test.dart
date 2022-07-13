import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/commands/type.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('type test', () {
    test('string, returns the correct type', () async {
      final key = newKey();
      final value = randomID();
      await SetCommand(key, value).exec(client);
      final res = await TypeCommand(key).exec(client);
      expect(res, ValueType.string);
    });

    test('list, returns the correct type', () async {
      final key = newKey();
      final value = randomID();
      await LPushCommand(key, [value]).exec(client);
      final res = await TypeCommand(key).exec(client);
      expect(res, ValueType.list);
    });

    test('set, returns the correct type', () async {
      final key = newKey();
      final value = randomID();
      await SAddCommand(key, [value]).exec(client);
      final res = await TypeCommand(key).exec(client);
      expect(res, ValueType.set);
    });

    test('hash, returns the correct type', () async {
      final key = newKey();
      final field = randomID();
      final value = randomID();
      await HSetCommand(key, {field: value}).exec(client);
      final res = await TypeCommand(key).exec(client);
      expect(res, ValueType.hash);
    });

    test('zset, returns the correct type', () async {
      final key = newKey();
      final member = randomID();
      await ZAddCommand(key, [ScoreMember(score: 0, member: member)])
          .exec(client);
      final res = await TypeCommand(key).exec(client);
      expect(res, ValueType.zset);
    });

    test('none, returns the correct type', () async {
      final key = newKey();
      final res = await TypeCommand(key).exec(client);
      expect(res, ValueType.none);
    });
  });
}
