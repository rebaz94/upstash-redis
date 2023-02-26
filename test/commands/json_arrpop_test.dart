import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_arrpop.dart';
import 'package:upstash_redis/src/commands/json_get.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('Pop a value from an index and insert a new value', () async {
    final key = newKey();
    final res1 = await JsonSetCommand(key, $, {
      "max_level": [80, 90, 100, 120]
    }).exec(client);
    expect(res1, 'OK');

    final res2 =
        await JsonArrPopCommand<int>(key, r'$.max_level', 0).exec(client);
    expect(res2, [80]);

    final res3 = await JsonGetCommand(key, [r'$.max_level']).exec(client);
    expect(res3, [
      [90, 100, 120]
    ]);
  });
}
