import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/mod.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('when key does not exist, does nothing', () async {
    final key = newKey();
    final res = await DelCommand([key]).exec(client);
    expect(res, 0);
  });

  test('when key does exist, deletes the key', () async {
    final key = newKey();
    await SetCommand(key, 'value').exec(client);
    final res = await DelCommand([key]).exec(client);
    expect(res, 1);
  });

  test('with multiple keys, when one does not exist, deletes all keys', () async {
    final key1 = newKey();
    final key2 = newKey();
    await SetCommand(key1, 'value').exec(client);
    final res = await DelCommand([key1, key2]).exec(client);
    expect(res, 1);
  });
}
