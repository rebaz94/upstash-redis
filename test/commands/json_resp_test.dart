import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_resp.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('Return an array of RESP details about a document', () async {
    final key = newKey();
    final res = await JsonSetCommand(key, $, {
      'name': 'Wireless earbuds',
      'description': 'Wireless Bluetooth in-ear headphones',
      'connection': {'wireless': true, 'type': 'Bluetooth'},
      'price': 64.99,
      'stock': 17,
      'colors': ['black', 'white'],
      'max_level': [80, 100, 120],
    }).exec(client);
    expect(res, 'OK');

    final res2 = await JsonRespCommand<List>(key).exec(client);
    expect(res2.length, 15);
  });
}
