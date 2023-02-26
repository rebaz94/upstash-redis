import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_mget.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('Return the values at path from multiple key arguments', () async {
    final key1 = newKey();
    final key2 = newKey();
    final res = await JsonSetCommand(key1, $, {
      'a': 1,
      'b': 2,
      'nested': {'a': 3},
      'c': null,
    }).exec(client);
    expect(res, 'OK');

    final res2 = await JsonSetCommand(key2, $, {
      'a': 4,
      'b': 5,
      'nested': {'a': 6},
      'c': null,
    }).exec(client);
    expect(res2, 'OK');

    final res3 = await JsonMGetCommand([key1, key2], r'$..a').exec(client);
    expect(res3, [
      [3, 1],
      [6, 4]
    ]);
  });
}
