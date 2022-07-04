import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zscore.dart';
import 'package:upstash_redis/src/test_utils.dart';
import 'dart:math' as math;

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('returns the score', () async {
    final key = newKey();
    final member = randomID();
    final score = math.Random().nextInt(100);
    await ZAddCommand.single(key, score: score, member: member).exec(client);
    final res = await ZScoreCommand(key, member).exec(client);
    expect(res, score);
  });
}
