import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/incrbyfloat.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('incrbyfloat command', () {
    test('increments a non-existing value', () async {
      final key = newKey();
      final res = await IncrByFloatCommand(key, 2.5).exec(client);
      expect(res, 2.5);
    });

    test('increments and existing value', () async {
      final key = newKey();
      await SetCommand(key, 5).exec(client);
      final res = await IncrByFloatCommand(key, 2.5).exec(client);
      expect(res, 7.5);
    });
  });
}
