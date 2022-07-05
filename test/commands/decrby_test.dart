import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/decrby.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('decrements a non-existing value', () async {
    final key = newKey();
    final res = await DecrByCommand(key, 2).exec(client);
    expect(res, -2);
  });

  test('decrements and existing value', () async {
    final key = newKey();
    await SetCommand(key, 5).exec(client);
    final res = await DecrByCommand(key, 2).exec(client);
    expect(res, 3);
  });
}
