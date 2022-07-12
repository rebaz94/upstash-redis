import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/commands/strlen.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('strlen test', () {
    test('returns the correct length', () async {
      final key = newKey();
      final value = 'abcd';
      await SetCommand(key, value).exec(client);
      final res = await StrLenCommand(key).exec(client);
      expect(res, value.length);
    });
  });
}
