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

  group('command format', () {
    test('without options, build the correct command', () async {
      final command =
          ZAddCommand.single('key', score: 0, member: 'member').command;

      expect(command, ['zadd', 'key', '0', 'member']);
    });

    test('with nx, build the correct command', () async {
      final command = ZAddCommand.single(
        'key',
        score: 0,
        member: 'member',
        nx: true,
      ).command;

      expect(command, ['zadd', 'key', 'nx', '0', 'member']);
    });

    test('with xx, build the correct command', () async {
      final command = ZAddCommand.single(
        'key',
        score: 0,
        member: 'member',
        xx: true,
      ).command;

      expect(command, ['zadd', 'key', 'xx', '0', 'member']);
    });

    test('with ch, build the correct command', () async {
      final command = ZAddCommand.single(
        'key',
        score: 0,
        member: 'member',
        ch: true,
      ).command;

      expect(command, ['zadd', 'key', 'ch', '0', 'member']);
    });

    test('with incr, build the correct command', () async {
      final command = ZAddCommand.single(
        'key',
        score: 0,
        member: 'member',
        incr: true,
      ).command;

      expect(command, ['zadd', 'key', 'incr', '0', 'member']);
    });

    test('with nx and ch, build the correct command', () async {
      final command = ZAddCommand.single(
        'key',
        score: 0,
        member: 'member',
        nx: true,
        ch: true,
      ).command;

      expect(command, ['zadd', 'key', 'nx', 'ch', '0', 'member']);
    });

    test('with nx,ch and incr, build the correct command', () async {
      final command = ZAddCommand.single(
        'key',
        score: 0,
        member: 'member',
        nx: true,
        ch: true,
        incr: true,
      ).command;

      expect(command, ['zadd', 'key', 'nx', 'ch', 'incr', '0', 'member']);
    });

    test('with nx and multiple members', () async {
      final command = ZAddCommand(
        'key',
        [
          const ScoreMember(score: 0, member: 'member'),
          const ScoreMember(score: 1, member: 'member1'),
        ],
        nx: true,
      ).command;

      expect(command, ['zadd', 'key', 'nx', '0', 'member', '1', 'member1']);
    });
  });

  test('without options, adds the member', () async {
    final key = newKey();
    final member = randomID();
    final score = math.Random().nextInt(100);
    final res = await ZAddCommand.single(key, score: score, member: member)
        .exec(client);

    expect(res, 1);
  });

  group('xx', () {
    test('when the element exists, updates the element', () async {
      final key = newKey();
      final member = randomID();
      final score = math.Random().nextInt(100);
      await ZAddCommand.single(key, score: score, member: member).exec(client);
      final newScore = score + 1;
      final res = await ZAddCommand.single(
        key,
        score: newScore,
        member: member,
        xx: true,
      ).exec(client);
      expect(res, 0);

      final res2 = await ZScoreCommand(key, member).exec(client);
      expect(res2, newScore);
    });

    test('when the element does not exist, does nothing', () async {
      final key = newKey();
      final member = randomID();
      final score = math.Random().nextInt(100);
      await ZAddCommand.single(key, score: score, member: member).exec(client);
      final newScore = score + 1;
      final res = await ZAddCommand.single(
        key,
        score: newScore,
        member: member,
        xx: true,
      ).exec(client);
      expect(res, 0);
    });
  });

  group('nx', () {
    test('when the element exists, does nothing', () async {
      final key = newKey();
      final member = randomID();
      final score = math.Random().nextInt(100);
      await ZAddCommand.single(key, score: score, member: member).exec(client);
      final newScore = score + 1;
      final res = await ZAddCommand.single(
        key,
        score: newScore,
        member: member,
        nx: true,
      ).exec(client);
      expect(res, 0);

      final res2 = await ZScoreCommand(key, member).exec(client);
      expect(res2, score);
    });

    test('when the element does not exist, creates element', () async {
      final key = newKey();
      final member = randomID();
      final score = math.Random().nextInt(100);
      final res = await ZAddCommand.single(
        key,
        score: score,
        member: member,
        nx: true,
      ).exec(client);
      expect(res, 1);
    });
  });

  group('ch', () {
    test('returns the number of changed elements', () async {
      final key = newKey();
      final member = randomID();
      final score = math.Random().nextInt(100);
      await ZAddCommand.single(key, score: score, member: member).exec(client);
      final newScore = score + 1;
      final res = await ZAddCommand.single(
        key,
        score: newScore,
        member: member,
        ch: true,
      ).exec(client);
      expect(res, 1);
    });
  });

  group('incr', () {
    test('returns the number with added increment', () async {
      final key = newKey();
      final member = randomID();
      final score = 10;
      await ZAddCommand.single(key, score: score, member: member).exec(client);
      final newScore = score + 1;
      final res = await ZAddCommand.single(
        key,
        score: newScore,
        member: member,
        incr: true,
      ).exec(client);
      expect(res, score + newScore);
    });
  });
}
