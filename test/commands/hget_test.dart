import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hget.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('gets an exiting value', () async {
    final key = newKey();
    final field = randomID();
    final value = randomID();
    await HSetCommand(key, {field: value}).exec(client);

    final res = await HGetCommand<String>(key, field).exec(client);
    expect(res, value);
  });

  test('gets a non-existing hash', () async {
    final key = newKey();
    final field = randomID();
    final res = await HGetCommand(key, field).exec(client);
    expect(res, null);
  });

  test('gets a non-existing field', () async {
    final key = newKey();
    final field = randomID();
    await HSetCommand(key, {randomID(): randomID()}).exec(client);

    final res = await HGetCommand(key, field).exec(client);
    expect(res, null);
  });

  test('gets an object', () async {
    final key = newKey();
    final field = randomID();
    final value = {'v': randomID()};
    await HSetCommand(key, {field: value}).exec(client);

    final res = await HGetCommand<Map<String, String>>(key, field).exec(client);
    expect(res, value);
  });
}
