import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hkeys.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('with existing hash, returns all keys', () async {
    final key = newKey();
    final kv = {
      randomID(): randomID(),
      randomID(): randomID(),
    };
    await HSetCommand(key, kv).exec(client);

    final res = await HKeysCommand(key).exec(client);
    expect(res..sort(), kv.keys.sorted());
  });

}
