import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zrem.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('gets an exiting value', () async {
    final key = newKey();
    final member1 = randomID();
    final member2 = randomID();

    await ZAddCommand(
      key,
      [
        ScoreMember(score: 1, member: member1),
        ScoreMember(score: 2, member: member2),
      ],
    ).exec(client);

    final res = await ZRemCommand(key, [member1, member2]).exec(client);
    expect(res, 2);
  });
}
