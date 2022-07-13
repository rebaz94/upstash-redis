import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zremrangebyscore.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zremrangebyscore', () {
    test('returns the number of removed elements', () async {
      final key = newKey();
      final member1 = randomID();
      final member2 = randomID();
      final member3 = randomID();

      await ZAddCommand(
        key,
        [
          ScoreMember(score: 1, member: member1),
          ScoreMember(score: 2, member: member2),
          ScoreMember(score: 3, member: member3),
        ],
      ).exec(client);

      final res = await ZRemRangeByScoreCommand(key, 1, 2).exec(client);
      expect(res, 2);
    });
  });
}
