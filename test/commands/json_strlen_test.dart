import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/commands/json_strlen.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('return the length', () async {
    final key = newKey();
    final res = await JsonSetCommand(key, $, {
      'a': 'foo',
      'nested': {'a': 'hello'},
      'nested2': {'a': 31},
    }).exec(client);
    expect(res, 'OK');

    final res2 = await JsonStrLenCommand(key, r'$..a').exec(client);
    expect(res2..sortedNullable(), [3, 5, null]);
  });
}
