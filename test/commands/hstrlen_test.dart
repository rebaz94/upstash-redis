import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/commands/hstrlen.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('hstrlen command', () {
    test('returns correct length', () async {
      final key = newKey();
      final field = randomID();
      final value = randomID();

      final res = await HStrLenCommand(key, field).exec(client);
      expect(res, 0);

      await HSetCommand(key, {field: value}).exec(client);

      final res2 = await HStrLenCommand(key, field).exec(client);
      expect(res2, value.length);
    });
  });
}
