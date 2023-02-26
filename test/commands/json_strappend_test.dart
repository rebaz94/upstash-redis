import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_get.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/commands/json_strappend.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test("Add 'baz' to existing string", () async {
    final key = newKey();
    final res = await JsonSetCommand(key, $, {
      'a': 'foo',
      'nested': {'a': 'hello'},
      'nested2': {'a': 31},
    }).exec(client);
    expect(res, 'OK');

    final res2 = await JsonStrAppendCommand(key, r'$..a', '"baz"').exec(client);
    expect(res2..sortedNullable(), [6, 8, null]);

    final res3 =
        await JsonGetCommand<Map<String, dynamic>>(key, const []).exec(client);
    expect(res3, {
      'a': 'foobaz',
      'nested': {'a': 'hellobaz'},
      'nested2': {'a': 31},
    });
  });
}
