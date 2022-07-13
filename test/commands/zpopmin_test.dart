import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zpopmin.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zpopmin', () {
    test('without options, returns the min', () async {
      final key = newKey();
      final score1 = 1;
      final score2 = 2;
      final member1 = randomID();
      final member2 = randomID();

      await ZAddCommand(
        key,
        [
          ScoreMember(score: score1, member: member1),
          ScoreMember(score: score2, member: member2),
        ],
      ).exec(client);
      final res = await ZPopMinCommand<String>(key).exec(client);
      expect(res, [member1, '$score1']);
    });

    test('with count, returns the n min members', () async {
      final key = newKey();
      final score1 = 1;
      final score2 = 2;
      final score3 = 2;
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
      final res = await ZPopMinCommand<String>(key, count: 2).exec(client);
      expect(res, [member1, '$score1', member2, '$score2']);
    });
  });
}
