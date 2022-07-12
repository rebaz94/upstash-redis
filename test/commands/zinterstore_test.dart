import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zinterstore.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zinterstore command', () {
    group('command format', () {
      test('without options, builds the correct command', () async {
        expect(ZInterStoreCommand('destination', 1, ['key']).command, [
          'zinterstore',
          'destination',
          '1',
          'key',
        ]);
      });

      test('with multiple keys, builds the correct command', () async {
        expect(ZInterStoreCommand('destination', 2, ['key1', 'key2']).command, [
          'zinterstore',
          'destination',
          '2',
          'key1',
          'key2',
        ]);
      });

      test('with single weight, builds the correct command', () async {
        expect(ZInterStoreCommand('destination', 1, ['key1'], weight: 4).command, [
          'zinterstore',
          'destination',
          '1',
          'key1',
          'weights',
          '4',
        ]);
      });

      test('with multiple weights, builds the correct command', () async {
        expect(ZInterStoreCommand('destination', 2, ['key1', 'key2'], weights: [2, 3]).command, [
          'zinterstore',
          'destination',
          '2',
          'key1',
          'key2',
          'weights',
          '2',
          '3',
        ]);
      });

      test('with aggregate, builds the correct command', () async {
        expect(
          ZInterStoreCommand('destination', 1, ['key1'], aggregate: AggregateType.sum).command,
          [
            'zinterstore',
            'destination',
            '1',
            'key1',
            'aggregate',
            'sum',
          ],
        );

        expect(
          ZInterStoreCommand('destination', 1, ['key1'], aggregate: AggregateType.min).command,
          [
            'zinterstore',
            'destination',
            '1',
            'key1',
            'aggregate',
            'min',
          ],
        );

        expect(
          ZInterStoreCommand('destination', 1, ['key1'], aggregate: AggregateType.max).command,
          [
            'zinterstore',
            'destination',
            '1',
            'key1',
            'aggregate',
            'max',
          ],
        );
      });

      test('complex, builds the correct command', () async {
        expect(
          ZInterStoreCommand(
            'destination',
            2,
            ['key1', 'key2'],
            weights: [4, 2],
            aggregate: AggregateType.max,
          ).command,
          [
            'zinterstore',
            'destination',
            '2',
            'key1',
            'key2',
            'weights',
            '4',
            '2',
            'aggregate',
            'max',
          ],
        );
      });
    });

    test('without options, returns the number of elements in the new set', () async {
      final destination = newKey();
      final key1 = newKey();
      final key2 = newKey();
      final score1 = 1;
      final member1 = randomID();
      final score2 = 2;
      final member2 = randomID();

      await ZAddCommand(key1, [ScoreMember(score: score1, member: member1)]).exec(client);
      await ZAddCommand(key2, [
        ScoreMember(score: score1, member: member1),
        ScoreMember(score: score2, member: member2),
      ]).exec(client);

      final res = await ZInterStoreCommand(destination, 2, [key1, key2]).exec(client);
      expect(res, 1);
    });

    test('with single weight, returns the number of elements in the new set', () async {
      final destination = newKey();
      final key1 = newKey();
      final key2 = newKey();
      final score1 = 1;
      final member1 = randomID();
      final score2 = 2;
      final member2 = randomID();

      await ZAddCommand(key1, [ScoreMember(score: score1, member: member1)]).exec(client);
      await ZAddCommand(key2, [
        ScoreMember(score: score1, member: member1),
        ScoreMember(score: score2, member: member2),
      ]).exec(client);

      final res = await ZInterStoreCommand(destination, 2, [key1, key2], weights: [2, 3]).exec(client);
      expect(res, 1);
    });

    test('with multiple weights, returns the number of elements in the new set', () async {
      final destination = newKey();
      final key1 = newKey();
      final key2 = newKey();
      final score1 = 1;
      final member1 = randomID();
      final score2 = 2;
      final member2 = randomID();

      await ZAddCommand(key1, [ScoreMember(score: score1, member: member1)]).exec(client);
      await ZAddCommand(key2, [
        ScoreMember(score: score1, member: member1),
        ScoreMember(score: score2, member: member2),
      ]).exec(client);

      final res = await ZInterStoreCommand(destination, 2, [key1, key2], weights: [1, 2]).exec(client);
      expect(res, 1);
    });

    test('aggregate - sum, returns the number of elements in the new set', () async {
      final destination = newKey();
      final key1 = newKey();
      final key2 = newKey();
      final score1 = 1;
      final member1 = randomID();
      final score2 = 2;
      final member2 = randomID();

      await ZAddCommand(key1, [ScoreMember(score: score1, member: member1)]).exec(client);
      await ZAddCommand(key2, [
        ScoreMember(score: score1, member: member1),
        ScoreMember(score: score2, member: member2),
      ]).exec(client);

      final res = await ZInterStoreCommand(destination, 2, [key1, key2], aggregate: AggregateType.sum)
          .exec(client);
      expect(res, 1);
    });

    test('aggregate - min, returns the number of elements in the new set', () async {
      final destination = newKey();
      final key1 = newKey();
      final key2 = newKey();
      final score1 = 1;
      final member1 = randomID();
      final score2 = 2;
      final member2 = randomID();

      await ZAddCommand(key1, [ScoreMember(score: score1, member: member1)]).exec(client);
      await ZAddCommand(key2, [
        ScoreMember(score: score1, member: member1),
        ScoreMember(score: score2, member: member2),
      ]).exec(client);

      final res = await ZInterStoreCommand(destination, 2, [key1, key2], aggregate: AggregateType.min)
          .exec(client);
      expect(res, 1);
    });

    test('aggregate - max, returns the number of elements in the new set', () async {
      final destination = newKey();
      final key1 = newKey();
      final key2 = newKey();
      final score1 = 1;
      final member1 = randomID();
      final score2 = 2;
      final member2 = randomID();

      await ZAddCommand(key1, [ScoreMember(score: score1, member: member1)]).exec(client);
      await ZAddCommand(key2, [
        ScoreMember(score: score1, member: member1),
        ScoreMember(score: score2, member: member2),
      ]).exec(client);

      final res = await ZInterStoreCommand(destination, 2, [key1, key2], aggregate: AggregateType.max)
          .exec(client);
      expect(res, 1);
    });
  });
}
