import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_forget.dart';
import 'package:upstash_redis/src/commands/json_get.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('Delete a value', () async {
    final key = newKey();
    final res1 = await JsonSetCommand(key, $, {
      'a': 1,
      'nested': {'a': 2, 'b': 3},
    }).exec(client);
    expect(res1, 'OK');

    final res2 = await JsonForgetCommand(key, r'$..a').exec(client);
    expect(res2, 2);

    final res3 = await JsonGetCommand(key, [$]).exec(client);
    expect(res3, [
      {
        'nested': {'b': 3}
      }
    ]);
  });
}
