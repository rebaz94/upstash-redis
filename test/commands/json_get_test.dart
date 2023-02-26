import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_get.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('Return the value at path in JSON serialized form', () async {
    final key = newKey();
    final res = await JsonSetCommand(key, $, {
      'a': 2,
      'b': 3,
      'nested': {'a': 4, 'b': null},
    }).exec(client);
    expect(res, 'OK');

    final res2 = await JsonGetCommand<List>(key, [r'$..b']).exec(client);
    expect(res2, [null, 3]);

    final res3 = await JsonGetCommand<List<int?>>(key, [r'$..b']).exec(client);
    expect(res3, [null, 3]);

    final res4 =
        await JsonGetCommand<Map<String, dynamic>>(key, ['..a', r'$..b'])
            .exec(client);
    expect(res4, {
      r'$..b': [null, 3],
      '..a': [4, 2]
    });
  });
}
