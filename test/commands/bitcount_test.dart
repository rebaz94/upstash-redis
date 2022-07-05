import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/bitcount.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('when key is not set, returns 0', () async {
    final key = newKey();
    final res = await BitCountCommand(key).exec(client);
    expect(res, 0);
  });

  test('when key is set, returns bitcount', () async {
    final key = newKey();
    final value = 'Hello World';
    await SetCommand(key, value).exec(client);
    final res = await BitCountCommand(key).exec(client);
    expect(res, 43);
  });

  test('with start and end, returns bitcount', () async {
    final key = newKey();
    final value = 'Hello World';
    await SetCommand(key, value).exec(client);
    final res = await BitCountCommand(key, start: 4, end: 8).exec(client);
    expect(res, 22);
  });
}
