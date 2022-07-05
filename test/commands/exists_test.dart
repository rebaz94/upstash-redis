import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/exists.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('when the key does not exists, it returns 0', () async {
    final key = newKey();
    final res = await ExistsCommand([key]).exec(client);
    expect(res, 0);
  });

  test('when the key exists, it returns 1', () async {
    final key = newKey();
    await SetCommand(key, 'value').exec(client);
    final res = await ExistsCommand([key]).exec(client);
    expect(res, 1);
  });

  test('with multiple keys, it returns the number of found keys', () async {
    final key1 = newKey();
    final key2 = newKey();
    final key3 = newKey();
    await SetCommand(key1, 'value').exec(client);
    await SetCommand(key2, 'value').exec(client);
    final res = await ExistsCommand([key1, key2, key3]).exec(client);
    expect(res, 2);
  });

}
