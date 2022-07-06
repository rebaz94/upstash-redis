import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hexists.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('returns 1 for an existing field', () async {
    final key = newKey();
    final field = randomID();
    await HSetCommand(key, {field: randomID()}).exec(client);
    final res = await HExistsCommand(key, field).exec(client);
    expect(res, 1);
  });

  test('returns 0 if field does not exist', () async {
    final key = newKey();
    await HSetCommand(key, {randomID(): randomID()}).exec(client);
    final res = await HExistsCommand(key, 'not-existing-field').exec(client);
    expect(res, 0);
  });

  test('returns 0 if hash does not exist', () async {
    final key = newKey();
    final field = randomID();
    await HSetCommand(key, {randomID(): randomID()}).exec(client);
    final res = await HExistsCommand(key, field).exec(client);
    expect(res, 0);
  });
}
