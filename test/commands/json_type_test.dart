import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/commands/json_type.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('return the type', () async {
    final key = newKey();
    final res1 = await JsonSetCommand(key, $, {
      'a': 2,
      'nested': {'a': true},
      'foo': 'bar',
    }).exec(client);
    expect(res1, 'OK');

    final res2 = await JsonTypeCommand(key, r'$..foo').exec(client);
    expect(res2..sort(), ['string']);

    final res3 = await JsonTypeCommand(key, r'$..a').exec(client);
    expect(res3..sort(), ['boolean', 'integer']);
  });
}
