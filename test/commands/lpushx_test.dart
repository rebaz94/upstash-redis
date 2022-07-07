import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/commands/lpushx.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('lpushx test', () {
    test('when list exists, returns the length after command', () async {
      final key = newKey();
      await LPushCommand(key, [randomID()]).exec(client);
      final res = await LPushXCommand(key, [randomID()]).exec(client);
      expect(res, 2);

      final res2 = await LPushXCommand(key, [randomID(), randomID()]).exec(client);
      expect(res2, 4);
    });

    test('when list does not exist, does nothing', () async {
      final key = newKey();
      final res = await LPushXCommand(key, [randomID()]).exec(client);
      expect(res, 0);
    });
  });
}
