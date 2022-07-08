import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/mget.dart';
import 'package:upstash_redis/src/commands/mset.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('mget command', () {
    test('gets an exiting value', () async {
      final key1 = newKey();
      final key2 = newKey();
      final value1 = randomID();
      final value2 = randomID();
      final kv = {key1: value1, key2: value2};
      final res = await MSetCommand(kv).exec(client);
      expect(res, 'OK');

      final res2 = await MGetCommand<String>([key1, key2]).exec(client);
      expect(res2, [value1, value2]);
    });

    test('gets a non-existing value', () async {
      final key = newKey();
      final res = await MGetCommand<Object?>([key]).exec(client);
      expect(res, [null]);
    });

    test('gets an object', () async {
      final key = newKey();
      final value = {'v': randomID()};
      await SetCommand(key, value).exec(client);
      final res = await MGetCommand<Map<String, String>>([key]).exec(client);
      expect(res, [value]);
    });
  });
}
