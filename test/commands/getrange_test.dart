import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/getrange.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('gets an exiting value', () async {
    final key = newKey();
    final value = 'Hello World';
    await SetCommand(key, value).exec(client);
    final res = await GetRangeCommand(key, 2, 4).exec(client);
    expect(res, value.substring(2, 5));
  });
}
