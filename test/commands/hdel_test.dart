import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hdel.dart';
import 'package:upstash_redis/src/commands/hget.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('deletes a hash that does not exist', () async {
    final key = newKey();
    final field = randomID();
    final res = await HDelCommand(key, field).exec(client);
    expect(res, 0);
  });

  test('deletes a field that exists', () async {
    final key = newKey();
    final field = randomID();
    await HSetCommand(key, {field: randomID()}).exec(client);

    final res = await HDelCommand(key, field).exec(client);
    expect(res, 1);

    final res2 = await HGetCommand(key, field).exec(client);
    expect(res2, null);
  });
}
