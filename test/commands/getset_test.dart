import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/get.dart';
import 'package:upstash_redis/src/commands/getset.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('overwrites the original value', () async {
    final key = newKey();
    final value = randomID();
    final newValue = randomID();
    await SetCommand(key, value).exec(client);
    final res = await GetSetCommand<String>(key, newValue).exec(client);
    expect(res, value);

    final res2 = await GetCommand(key).exec(client);
    expect(res2, newValue);
  });

  test('sets a new value if empty', () async {
    final key = newKey();
    final newValue = randomID();
    final res = await GetSetCommand<String>(key, newValue).exec(client);
    expect(res, null);

    final res2 = await GetCommand(key).exec(client);
    expect(res2, newValue);
  });
}
