import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_arrappend.dart';
import 'package:upstash_redis/src/commands/json_arrtrim.dart';
import 'package:upstash_redis/src/commands/json_get.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('Trim an array to a specific set of values', () async {
    final key = newKey();
    final res1 = await JsonSetCommand(key, $, {
      'a': [1]
    }).exec(client);
    expect(res1, 'OK');

    final res2 = await JsonArrAppendCommand(key, r'$.a', 2).exec(client);
    expect(res2..sort(), [2]);

    final res3 = await JsonArrTrimCommand(key, r'$.a', 1, 1).exec(client);
    expect(res3, [1]);

    final res4 = await JsonGetCommand(key, [r'$.a']).exec(client);
    expect(res4, [
      [2]
    ]);
  });
}
