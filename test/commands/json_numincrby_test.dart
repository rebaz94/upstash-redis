import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_numincrby.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('return the incremented value', () async {
    final key = newKey();
    final res = await JsonSetCommand(key, $, {
      'a': 'b',
      "b": [
        {"a": 2},
        {"a": 5},
        {"a": "c"}
      ],
    }).exec(client);
    expect(res, 'OK');

    final res2 = await JsonNumIncrByCommand(key, r'$.a', 2).exec(client);
    expect(res2..sortedNullable(), [null]);

    final res3 = await JsonNumIncrByCommand(key, r'$..a', 2).exec(client);
    expect(res3..sortedNullable(), [4, 7, null, null]);
  });
}
