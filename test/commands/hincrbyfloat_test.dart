import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hincrbyfloat.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('increments a non-existing value', () async {
    final key = newKey();
    final field = randomID();
    final res = await HIncrByFloatCommand(key, field, 2.5).exec(client);
    expect(res, 2.5);
  });

  test('increments an existing value', () async {
    final key = newKey();
    final field = randomID();
    await HSetCommand(key, {field: 5}).exec(client);
    final res = await HIncrByFloatCommand(key, field, 2.5).exec(client);
    expect(res, 7.5);
  });
}
