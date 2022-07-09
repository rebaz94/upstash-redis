import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/get.dart';
import 'package:upstash_redis/src/commands/mget.dart';
import 'package:upstash_redis/src/commands/msetnx.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('msetnx test', () {
    test('sets values', () async {
      final key1 = newKey();
      final key2 = newKey();
      final value1 = randomID();
      final value2 = randomID();
      final kv = {key1: value1, key2: value2};

      final res = await MSetNXCommand(kv).exec(client);
      expect(res, 1);

      final res2 = await MGetCommand<String>([key1, key2]).exec(client);
      expect(res2, [value1, value2]);
    });

    test('does not set values if one key already exists', () async {
      final key1 = newKey();
      final key2 = newKey();
      final value1 = randomID();
      final value2 = randomID();
      await SetCommand(key1, value1).exec(client);

      final kv = {key1: value1, key2: value2};
      final res = await MSetNXCommand(kv).exec(client);
      expect(res, 0);

      final res2 = await GetCommand<String>([key2]).exec(client);
      expect(res2, null);
    });
  });
}
