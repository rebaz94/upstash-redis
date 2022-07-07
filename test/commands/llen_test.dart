import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/llen.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('llen test', () {
    test('when list exists, returns the length of the list', () async {
      final key = newKey();
      await LPushCommand(key, [randomID()]).exec(client);
      final res = await LLenCommand(key).exec(client);
      expect(res, 1);
    });

    test('when list does not exist, returns 0', () async {
      final key = newKey();
      final res = await LLenCommand(key).exec(client);
      expect(res, 0);
    });
  });
}
