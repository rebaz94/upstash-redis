import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/lpop.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('lpop test', () {
    test('when list exists, returns the first element', () async {
      final key = newKey();
      final value = randomID();
      await LPushCommand(key, [value]).exec(client);
      final res = await LPopCommand<String>(key).exec(client);
      expect(res, value);
    });

    test('when list does not exist, returns null', () async {
      final key = newKey();
      final res = await LPopCommand(key).exec(client);
      expect(res, null);
    });
  });
}
