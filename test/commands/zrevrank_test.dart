import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zrevrank.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zrevrank', () {
    test('returns the rank', () async {
      final key = newKey();
      await ZAddCommand(
        key,
        [
          ScoreMember(score: 1, member: 'member1'),
          ScoreMember(score: 2, member: 'member2'),
          ScoreMember(score: 3, member: 'member3'),
        ],
      ).exec(client);

      final res = await ZRevRankCommand(key, 'member2').exec(client);
      expect(res, 1);
    });
  });
}
