import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_objkeys.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('return the keys', () async {
    final key = newKey();
    final res1 = await JsonSetCommand(key, $, {
      'a': [3],
      'nested': {
        'a': {'b': 2, 'c': 1}
      },
    }).exec(client);
    expect(res1, 'OK');

    final res2 = await JsonObjKeysCommand(key, r'$..a').exec(client);
    for (var e in res2) {
      e?.sort();
    }

    expect(res2, [
      ['b', 'c'],
      null
    ]);
  });
}
