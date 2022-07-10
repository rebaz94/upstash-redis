import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/pttl.dart';
import 'package:upstash_redis/src/commands/setex.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('pttl test', () {
    test('returns the ttl on a key', () async {
      final key = newKey();
      final ttl = 60;
      await SetExCommand(key, ttl, 'value').exec(client);
      final res = await PTtlCommand(key).exec(client);
      expect(res, lessThanOrEqualTo(ttl * 1000));
    });
  });
}
