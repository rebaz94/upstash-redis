import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hmget.dart';
import 'package:upstash_redis/src/commands/hmset.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('gets exiting values', () async {
    final key = newKey();
    final kv = {
      randomID(): randomID(),
      randomID(): randomID(),
    };
    final res = await HMSetCommand(key, kv).exec(client);
    expect(res, 'OK');

    final res2 = await HMGetCommand<String>(key, kv.keys.toList()).exec(client);
    expect(res2, kv);
  });

}
