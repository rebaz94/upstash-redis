import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hget.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('sets value', () async {
    final key = newKey();
    final field = randomID();
    final value = randomID();

    final res = await HSetCommand(key, {field: value}).exec(client);
    expect(res, 1);

    final res2 = await HGetCommand<String>(key, field).exec(client);
    expect(res2, value);
  });
}
