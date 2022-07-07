import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/commands/rpop.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('rpop test', () {
    test('when list exists, returns the last element', () async {
      final key = newKey();
      final value = randomID();
      await LPushCommand(key, [value]).exec(client);
      final res = await RPopCommand<String>(key).exec(client);
      expect(res, value);
    });

    test('when list does not exist, returns null', () async {
      final key = newKey();
      final res = await RPopCommand(key).exec(client);
      expect(res, null);
    });
  });
}
