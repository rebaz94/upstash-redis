import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/mget.dart';
import 'package:upstash_redis/src/commands/mset.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('mset test', () {
    test('gets exiting values', () async {
      final key1 = newKey();
      final key2 = newKey();
      final kv = {key1: randomID(), key2: randomID()};

      final res = await MSetCommand(kv).exec(client);
      expect(res, 'OK');

      final res2 = await MGetCommand<String>([key1, key2]).exec(client);
      expect(res2, kv.values.toList());
    });
  });
}
