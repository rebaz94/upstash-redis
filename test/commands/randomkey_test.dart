import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/randomkey.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('randomkey test', () {
    test('returns a random key', () async {
      final key = newKey();
      await SetCommand(key, randomID()).exec(client);
      final res = await RandomKeyCommand().exec(client);
      expect(res.runtimeType, String);
    });
  });
}
