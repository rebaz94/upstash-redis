import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/bitpos.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('when key is not set, returns 0', () async {
    final key = newKey();
    final res = await BitPosCommand(key, 0, 1, 1).exec(client);
    expect(res, -1);
  });

  test('when key is set, returns position of first set bit', () async {
    final key = newKey();
    final value = 'Hello World';
    await SetCommand(key, value).exec(client);
    final res = await BitPosCommand(key, 0, 2, 3).exec(client);
    expect(res, 24);
  });
}
