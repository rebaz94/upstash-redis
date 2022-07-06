import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hlen.dart';
import 'package:upstash_redis/src/commands/hmset.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('with existing hash, returns correct number of keys', () async {
    final key = newKey();
    final field1 = randomID();
    final field2 = randomID();
    final kv = {
      field1: randomID(),
      field2: randomID(),
    };
    await HMSetCommand(key, kv).exec(client);

    final res = await HLenCommand(key).exec(client);
    expect(res, 2);
  });

}
