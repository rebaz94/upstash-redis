import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/keys.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('keys test', () {
    test('when keys are found, returns keys', () async {
      final key = newKey();
      await SetCommand(key, 'value').exec(client);
      final res2 = await KeysCommand(key).exec(client);
      expect(res2, [key]);
    });
  });
}
