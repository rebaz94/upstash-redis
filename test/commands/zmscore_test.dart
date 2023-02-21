import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zmscore.dart';
import 'package:upstash_redis/src/test_utils.dart';
import 'dart:math' as math;

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('returns the score for single member', () async {
    final key = newKey();
    final member = randomID();
    final score = math.Random().nextInt(10);
    await ZAddCommand.single(key, score: score, member: member).exec(client);
    final res = await ZMScoreCommand(key, [member]).exec(client);
    expect(res, [score]);
  });

  test('returns the score for multiple members', () async {
    final key = newKey();
    final member1 = randomID();
    final member2 = randomID();
    final member3 = randomID();
    final score1 = math.Random().nextInt(10);
    final score2 = math.Random().nextInt(10);
    final score3 = math.Random().nextInt(10);
    await ZAddCommand(
      key,
      [
        ScoreMember(score: score1, member: member1),
        ScoreMember(score: score2, member: member2),
        ScoreMember(score: score3, member: member3),
      ],
    ).exec(client);
    final res =
        await ZMScoreCommand(key, [member1, member2, member3]).exec(client);
    expect(res, [score1, score2, score3]);
  });
}
