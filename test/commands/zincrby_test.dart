import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zincrby.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zincrby command', () {
    test('increments and existing value', () async {
      final key = newKey();
      final score = 1;
      final member = randomID();
      await ZAddCommand(key, [ScoreMember(score: score, member: member)]).exec(client);
      final res = await ZIncrByCommand(key, 2, member).exec(client);
      expect(res, 3);
    });
  });
}
