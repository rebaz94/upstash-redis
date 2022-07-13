import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zremrangebyrank.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zremrangebyrank', () {
    test('returns the number of removed elements', () async {
      final key = newKey();
      final score1 = 1;
      final score2 = 2;
      final score3 = 3;
      final member1 = randomID();
      final member2 = randomID();
      final member3 = randomID();

      await ZAddCommand(
        key,
        [
          ScoreMember(score: score1, member: member1),
          ScoreMember(score: score2, member: member2),
          ScoreMember(score: score3, member: member3),
        ],
      ).exec(client);

      final res = await ZRemRangeByRankCommand(key, 1, 3).exec(client);
      expect(res, 2);
    });
  });
}
