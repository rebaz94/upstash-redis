import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/json_get.dart';
import 'package:upstash_redis/src/commands/json_set.dart';
import 'package:upstash_redis/src/commands/json_toggle.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('Toggle a Boolean value stored at path', () async {
    final key = newKey();
    final res1 = await JsonSetCommand(key, $, {'bool': true}).exec(client);
    expect(res1, 'OK');

    final res2 = await JsonToggleCommand(key, r'$.bool').exec(client);
    expect(res2, [0]);

    final res3 = await JsonGetCommand(key, [$]).exec(client);
    expect(res3, [
      {"bool": false}
    ]);

    final res4 = await JsonToggleCommand(key, r'$.bool').exec(client);
    expect(res4, [1]);

    final res5 = await JsonGetCommand(key, [$]).exec(client);
    expect(res5, [
      {"bool": true}
    ]);
  });
}
