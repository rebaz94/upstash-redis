import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_arrappend.dart';
import 'package:upstash_redis/src/commands/json_get.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('Add a new color to a list of product colors', () async {
    final key = newKey();
    final res1 = await JsonSetCommand(
      key,
      $,
      {
        "name": "Noise-cancelling Bluetooth headphones",
        "description":
            "Wireless Bluetooth headphones with noise-cancelling technology",
        "connection": {"wireless": true, "type": "Bluetooth"},
        "price": 99.98,
        "stock": 25,
        "colors": ["black", "silver"],
      },
    ).exec(client);
    expect(res1, 'OK');

    final res2 =
        await JsonArrAppendCommand(key, r'$.colors', '"blue"').exec(client);
    expect(res2, [3]);

    final res3 = await JsonGetCommand(key, []).exec(client);
    expect(res3, {
      "name": "Noise-cancelling Bluetooth headphones",
      "description":
          "Wireless Bluetooth headphones with noise-cancelling technology",
      "connection": {"wireless": true, "type": "Bluetooth"},
      "price": 99.98,
      "stock": 25,
      "colors": ["black", "silver", "blue"],
    });
  });
}
