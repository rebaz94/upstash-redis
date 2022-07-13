import 'dart:convert';

import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
import 'package:upstash_redis/src/commands/zpopmax.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('zpopmax', () {
    test('without options, returns the max', () async {
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
      final res = await ZPopMaxCommand<String>(key).exec(client);
      expect(res.length, 2);
      expect(res.first, member2);
      expect(res.last, '$score2');
    });

    test('with count, returns the n max members', () async {
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
      final res = await ZPopMaxCommand<String>(key, count: 2).exec(client);
      expect(res, [member2, '$score2', member1, '$score1']);
    });

    test('custom deserializer', () async {
      final key = newKey();
      final score1 = 1;
      final score2 = 2;
      final score3 = 3;
      final score4 = 4;
      final member1 = {'v': 'v1', 'b': false};
      final member2 = {'v': 'v2', 'b': true};
      final member3 = {'v': 'v3', 'b': true};
      final member4 = {'v': 'v4', 'b': true};

      await ZAddCommand(
        key,
        [
          ScoreMember(score: score1, member: member1),
          ScoreMember(score: score2, member: member2),
          ScoreMember(score: score3, member: member3),
          ScoreMember(score: score4, member: member4),
        ],
      ).exec(client);
      final res = await ZPopMaxCommand(
        key,
        count: 4,
        opts: CommandOption(
          deserialize: (result) {
            final items = <PoppedData>[];
            for (int i = 0; i < result.length; i = i + 2) {
              items.add(
                PoppedData.parse(
                  result[i] as String,
                  result[i + 1] as String,
                ),
              );
            }
            return items;
          },
        ),
      ).exec(client);
      expect(res.length, 4);
      expect(res.first.member, member4);
      expect(res.first.score, score4);
    });
  });
}

class PoppedData {
  PoppedData({
    required this.member,
    required this.score,
  });

  factory PoppedData.parse(String member, String score) {
    return PoppedData(
      member: Map<String, dynamic>.from(jsonDecode(member)),
      score: int.parse(score),
    );
  }

  final Map<String, dynamic> member;
  final int score;
}
