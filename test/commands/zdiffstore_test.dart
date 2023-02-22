import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zdiffstore.dart';
import 'package:upstash_redis/src/commands/zrange.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('stores the diff', () async {
    final key1 = newKey();
    final key2 = newKey();
    final out = newKey();
    await ZAddCommand(key1, [
      ScoreMember(score: 1, member: 'one'),
      ScoreMember(score: 2, member: 'two'),
      ScoreMember(score: 3, member: 'three'),
    ]).exec(client);
    await ZAddCommand(key2, [
      ScoreMember(score: 1, member: 'one'),
      ScoreMember(score: 2, member: 'two'),
    ]).exec(client);

    final res = await ZDiffStoreCommand(out, 2, [key1, key2]).exec(client);
    expect(res, 1);

    final zset3 =
        await ZRangeCommand<String>(out, 0, -1, withScores: true).exec(client);
    expect(zset3[0], 'three');
    expect(zset3[1], '3');
  });
}
