import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/mset.dart';
import 'package:upstash_redis/src/commands/touch.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('touch test', () {
    test('returns the number of touched keys', () async {
      final key1 = newKey();
      final key2 = newKey();
      final kv = {key1: randomID(), key2: randomID()};
      await MSetCommand(kv).exec(client);
      final res = await TouchCommand([key1, key2]).exec(client);
      expect(res, 2);
    });
  });
}
