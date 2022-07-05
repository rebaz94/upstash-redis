import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/mod.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('expires a key correctly', () async {
    final key = newKey();
    final value = randomID();
    await SetCommand(key, value).exec(client);
    final res = await ExpireCommand(key, 1).exec(client);
    expect(res, 1);
    await Future.delayed(const Duration(seconds: 2));
    final res2 = await GetCommand<String>([key]).exec(client);
    expect(res2, null);
  });
}
