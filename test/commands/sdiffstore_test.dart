import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/sdiffstore.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('sdiffstore', () {
    test('returns the diff', () async {
      final key1 = newKey();
      final key2 = newKey();
      final member1 = randomID();
      final member2 = randomID();
      final destination = newKey();
      await SAddCommand(key1, [member1]).exec(client);
      await SAddCommand(key2, [member2]).exec(client);
      final res =
          await SDiffStoreCommand([destination, key1, key2]).exec(client);
      expect(res, 1);
    });
  });
}
