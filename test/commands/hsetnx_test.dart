import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hget.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/commands/hsetnx.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('hsetnx command', () {
    test('when hash exists already, returns 0', () async {
      final key = newKey();
      final field = randomID();
      final value = randomID();
      final newValue = randomID();

      await HSetCommand(key, {field: value}).exec(client);
      final res = await HSetNXCommand(key, field, newValue).exec(client);
      expect(res, 0);

      final res2 = await HGetCommand<String>(key, field).exec(client);
      expect(res2, value);
    });

    test('when hash does not exist, returns 1', () async {
      final key = newKey();
      final field = randomID();
      final value = randomID();
      final res = await HSetNXCommand(key, field, value).exec(client);
      expect(res, 1);

      final res2 = await HGetCommand<String>(key, field).exec(client);
      expect(res2, value);
    });
  });
}
