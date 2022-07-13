import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zremrangebylex.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zremrangebylex', () {
    test('returns the number of elements removed', () async {
      final key = newKey();
      await ZAddCommand(
        key,
        [
          ScoreMember(score: 0, member: 'aaaa'),
          ScoreMember(score: 0, member: 'b'),
          ScoreMember(score: 0, member: 'c'),
          ScoreMember(score: 0, member: 'd'),
          ScoreMember(score: 0, member: 'e'),
        ],
      ).exec(client);

      final res = await ZRemRangeByLexCommand(key, '[b', '[e').exec(client);
      expect(res, 4);
    });
  });
}
