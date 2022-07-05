import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/setbit.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('returns the original bit', () async {
    final key = newKey();
    final res = await SetBitCommand(key, 0, 1).exec(client);
    expect(res, 0);

    final res2 = await SetBitCommand(key, 0, 1).exec(client);
    expect(res2, 1);
  });
}
