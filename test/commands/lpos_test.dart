import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/lpos.dart';
import 'package:upstash_redis/src/commands/rpush.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('lpos test', () {
    test('with single element, returns 1', () async {
      final key = newKey();
      final value1 = randomID();
      final value2 = randomID();
      await RPushCommand(key, [value1, value2]).exec(client);
      final res = await LPosCommand<int>(key, value2).exec(client);
      expect(res, 1);
    });

    test('with rank, returns 6', () async {
      final key = newKey();
      await RPushCommand(key, ['a', 'b', 'c', 1, 2, 3, 'c', 'c']).exec(client);
      final cmd = LPosCommand<int>(key, 'c', rank: 2);
      expect(cmd.command, ['lpos', key, 'c', 'rank', '2']);
      final res = await cmd.exec(client);
      expect(res, 6);
    });

    test('with count, returns 2,6', () async {
      final key = newKey();
      await RPushCommand(key, ['a', 'b', 'c', 1, 2, 3, 'c', 'c']).exec(client);
      final res = await LPosCommand<List<int>>(key, 'c', count: 2).exec(client);
      expect(res, [2, 6]);
    });

    test('with maxLen, returns 2', () async {
      final key = newKey();
      await RPushCommand(key, ['a', 'b', 'c', 1, 2, 3, 'c', 'c']).exec(client);
      final res = await LPosCommand<List<int>>(key, 'c', count: 2, maxLen: 4).exec(client);
      expect(res, [2]);
    });

  });
}
