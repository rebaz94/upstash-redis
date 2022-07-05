import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/dbsize.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('returns the db size', () async {
    final key = newKey();
    final value = randomID();
    await SetCommand(key, value).exec(client);
    final res = await DbSizeCommand().exec(client);
    expect(res, greaterThan(0));
  });
}
