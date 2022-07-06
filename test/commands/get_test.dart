import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/get.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('get command', () {
    test('gets an exiting value', () async {
      final key = newKey();
      final value = randomID();
      await SetCommand(key, value).exec(client);
      final res = await GetCommand<String>([key]).exec(client);
      expect(res, value);
    });

    test('gets a non-existing value', () async {
      final key = newKey();
      final res = await GetCommand<String>([key]).exec(client);
      expect(res, null);
    });

    test('gets an object', () async {
      final key = newKey();
      final value = {'v': randomID()};
      await SetCommand(key, value).exec(client);
      try {
        final res = await GetCommand<Map<String, String>>([key]).exec(client);
        expect(res, value);
      } catch (e, stack) {
        print(e);
        print(stack);
      }
    });
  });
}
