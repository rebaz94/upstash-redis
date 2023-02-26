import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_clear.dart';
import 'package:upstash_redis/src/commands/json_get.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('Clear container values and set numeric values to 0', () async {
    final key = newKey();
    final res1 = await JsonSetCommand(
      key,
      $,
      '{"obj":{"a":1, "b":2}, "arr":[1,2,3], "str": "foo", "bool": true, "int": 42, "float": 3.14}',
    ).exec(client);
    expect(res1, 'OK');

    final res2 = await JsonClearCommand(key, r'$.*').exec(client);
    expect(res2, 4);

    final res3 = await JsonGetCommand(key, [$]).exec(client);
    expect(res3, [
      {
        'obj': {},
        'arr': [],
        'str': "foo",
        'bool': true,
        'int': 0,
        'float': 0,
      }
    ]);
  });
}
