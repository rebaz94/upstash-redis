import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/lindex.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('lindex test', () {
    test('when the index is in range, returns the element at index', () async {
      final key = newKey();
      final value = randomID();

      await LPushCommand(key, [value]).exec(client);
      final res = await LIndexCommand<String>(key, 0).exec(client);
      expect(res, value);
    });

    test('when the index is out of bounds, returns null', () async {
      final key = newKey();
      final value = randomID();

      await LPushCommand(key, [value]).exec(client);
      final res = await LIndexCommand<String>(key, 1).exec(client);
      expect(res, null);
    });
  });
}
