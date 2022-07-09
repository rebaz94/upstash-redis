import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/get.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('without options, sets value', () async {
    final key = newKey();
    final value = randomID();
    final res = await SetCommand(key, value).exec(client);
    expect(res, 'OK');
    final res2 = await GetCommand<String>(key).exec(client);
    expect(res2, value);
  });

  test('ex, sets value', () async {
    final key = newKey();
    final value = randomID();

    final res = await SetCommand(key, value, ex: 1).exec(client);
    expect(res, 'OK');
    final res2 = await GetCommand<String>(key).exec(client);
    expect(res2, value);

    await Future.delayed(const Duration(seconds: 2));
    final res3 = await GetCommand<String>(key).exec(client);
    expect(res3, null);
  });

  test('px, sets value', () async {
    final key = newKey();
    final value = randomID();

    final res = await SetCommand(key, value, px: 1000).exec(client);
    expect(res, 'OK');
    final res2 = await GetCommand<String>(key).exec(client);
    expect(res2, value);

    await Future.delayed(const Duration(seconds: 2));
    final res3 = await GetCommand<String>(key).exec(client);
    expect(res3, null);
  });

  test('nx, when key exists, does nothing', () async {
    final key = newKey();
    final value = randomID();
    final newValue = randomID();

    await SetCommand(key, value).exec(client);
    final res = await SetCommand(key, newValue, nx: true).exec(client);
    expect(res, null);
    final res2 = await GetCommand<String>(key).exec(client);
    expect(res2, value);
  });

  test('nx, when key does not exists, overwrites key', () async {
    final key = newKey();
    final value = randomID();

    final res = await SetCommand(key, value, nx: true).exec(client);
    expect(res, 'OK');
    final res2 = await GetCommand<String>(key).exec(client);
    expect(res2, value);
  });

  test('xx, when key exists, overwrites key', () async {
    final key = newKey();
    final value = randomID();
    final newValue = randomID();

    await SetCommand(key, value).exec(client);
    final res = await SetCommand(key, newValue, xx: true).exec(client);
    expect(res, 'OK');
    final res2 = await GetCommand<String>(key).exec(client);
    expect(res2, newValue);
  });

  test('xx, when key does not exists, does nothing', () async {
    final key = newKey();
    final value = randomID();

    final res = await SetCommand(key, value, xx: true).exec(client);
    expect(res, null);
    final res2 = await GetCommand<String>(key).exec(client);
    expect(res2, null);
  });
}
