import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zrange.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zrange', () {
    test('without options, returns the set', () async {
      final key = newKey();
      final score1 = 2;
      final score2 = 5;
      final member1 = randomID();
      final member2 = randomID();

      await ZAddCommand(
        key,
        [
          ScoreMember(score: score1, member: member1),
          ScoreMember(score: score2, member: member2),
        ],
      ).exec(client);

      final res = await ZRangeCommand<String>(key, 1, 3).exec(client);
      expect(res.length, 1);
      expect(res[0], member2);
    });

    test('withscores, returns the set', () async {
      final key = newKey();
      final score1 = 2;
      final score2 = 5;
      final member1 = randomID();
      final member2 = randomID();

      await ZAddCommand(
        key,
        [
          ScoreMember(score: score1, member: member1),
          ScoreMember(score: score2, member: member2),
        ],
      ).exec(client);

      final res = await ZRangeCommand<String>(key, 1, 3, withScores: true).exec(client);
      expect(res.length, 2);
      expect(res[0], member2);
      expect(res[1], '$score2');
    });

    test('byscore, returns the set', () async {
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

      final res = await ZRangeCommand<String>(key, score1, score2, byScore: true).exec(client);
      expect(res.length, 2);
      expect(res[0], member1);
      expect(res[1], member2);

      final res2 = await ZRangeCommand<String>(key, score1, score3, byScore: true).exec(client);
      expect(res2.length, 3);
      expect(res2[0], member1);
      expect(res2[1], member2);
      expect(res2[2], member3);

      final res3 = await ZRangeCommand<String>(key, '-inf', '+inf', byScore: true).exec(client);
      expect(res3, res2);
    });

    test('bylex, returns the set', () async {
      final key = newKey();
      await ZAddCommand(
        key,
        [
          ScoreMember(score: 0, member: 'a'),
          ScoreMember(score: 0, member: 'b'),
          ScoreMember(score: 0, member: 'c'),
        ],
      ).exec(client);

      // everything in between a and c, excluding "a" and including "c"
      final res = await ZRangeCommand<String>(key, '(a', '[c', byLex: true).exec(client);
      expect(res.length, 2);
      expect(res[0], 'b');
      expect(res[1], 'c');

      //everything after "a", excluding a
      final res2 = await ZRangeCommand<String>(key, '(a', '+', byLex: true).exec(client);
      expect(res2, res);

      // everything in between a and "bb", including "a" and excluding "bb"
      final res3 = await ZRangeCommand<String>(key, '[a', '(bb', byLex: true).exec(client);
      expect(res.length, 2);
      expect(res3[0], 'a');
      expect(res3[1], 'b');
    });

    test('rev, returns the set in reverse order', () async {
      final key = newKey();
      final score1 = 2;
      final score2 = 5;
      final member1 = randomID();
      final member2 = randomID();
      await ZAddCommand(
        key,
        [
          ScoreMember(score: score1, member: member1),
          ScoreMember(score: score2, member: member2),
        ],
      ).exec(client);

      final res = await ZRangeCommand<String>(key, 0, 7, rev: true).exec(client);
      expect(res.length, 2);
      expect(res[0], member2);
      expect(res[1], member1);
    });

    test('limit, returns only the first 2', () async {
      final key = newKey();
      for (int i = 0; i < 10; i++) {
        await ZAddCommand(key, [ScoreMember(score: i, member: randomID())]).exec(client);
      }

      final res = await ZRangeCommand<String>(key, 0, 7, offset: 0, count: 2).exec(client);
      expect(res.length, 2);
    });
  });
}
