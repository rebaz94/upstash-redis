import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zcard.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zcard test', () {
    test('returns the cardinality', () async {
      final key = newKey();
      await ZAddCommand(key, [ScoreMember(score: 1, member: 'member1')]).exec(client);
      final res = await ZCardCommand(key).exec(client);
      expect(res, 1);
    });
  });
}
