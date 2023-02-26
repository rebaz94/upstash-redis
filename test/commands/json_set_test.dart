import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_get.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('replace an existing value', () async {
    final key = newKey();
    final res = await JsonSetCommand(key, $, {'a': 2}).exec(client);
    expect(res, 'OK');

    final res2 = await JsonSetCommand(key, r'$.a', 3).exec(client);
    expect(res2, 'OK');

    final res3 = await JsonGetCommand(key, [$]).exec(client);
    expect(res3, [
      {'a': 3}
    ]);
  });

  test('add a new value', () async {
    final key = newKey();
    final res = await JsonSetCommand(key, $, {'a': 2}).exec(client);
    expect(res, 'OK');

    final res2 = await JsonSetCommand(key, r'$.b', 8).exec(client);
    expect(res2, 'OK');

    final res3 = await JsonGetCommand(key, [$]).exec(client);
    expect(res3, [
      {'a': 2, 'b': 8},
    ]);
  });

  test('update multi-paths', () async {
    final key = newKey();
    final res = await JsonSetCommand(key, $, {
      'f1': {'a': 1},
      'f2': {'a': 2}
    }).exec(client);
    expect(res, 'OK');

    final res2 = await JsonSetCommand(key, r'$..a', 3).exec(client);
    expect(res2, 'OK');

    final res3 = await JsonGetCommand(key, [$]).exec(client);
    // TODO: fix this latter: #313
    expect(res3, [
      {
        'f1': {'a': 3},
        'f2': {'a': 3},
        'a': 3
      }
    ]);
  });
}
