import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/decr.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('decrements a non-existing value', () async {
    final key = newKey();
    final res = await DecrCommand(key).exec(client);
    expect(res, -1);
  });

  test('decrements and existing value', () async {
    final key = newKey();
    await SetCommand(key, 4).exec(client);
    final res = await DecrCommand(key).exec(client);
    expect(res, 3);
  });
}
