import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/getbit.dart';
import 'package:upstash_redis/src/commands/setbit.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('returns the bit at offset', () async {
    final key = newKey();
    await SetBitCommand(key, 0, 1).exec(client);
    final res = await GetBitCommand(key, 0).exec(client);
    expect(res, 1);
  });
}
