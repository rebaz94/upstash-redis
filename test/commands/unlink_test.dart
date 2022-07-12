import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/mset.dart';
import 'package:upstash_redis/src/commands/unlink.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('unlink test', () {
    test('unlinks the keys', () async {
      final key1 = newKey();
      final key2 = newKey();
      final key3 = newKey();
      final kv = {key1: randomID(), key2: randomID()};
      await MSetCommand(kv).exec(client);
      final res = await UnlinkCommand([key1, key2, key3]).exec(client);
      expect(res, 2);
    });
  });
}
