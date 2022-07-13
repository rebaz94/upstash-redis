import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zlexcount.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zlexcount test', () {
    test('returns the number of elements in the specified score range', () async {
      final key = newKey();
      await ZAddCommand(
        key,
        const [
          ScoreMember(score: 0, member: 'a'),
          ScoreMember(score: 0, member: 'b'),
          ScoreMember(score: 0, member: 'c'),
          ScoreMember(score: 0, member: 'd'),
          ScoreMember(score: 0, member: 'e'),
        ],
      ).exec(client);
      final res = await ZLexCountCommand(key, '[b', '[f').exec(client);
      expect(res, 4);
    });
  });
}
