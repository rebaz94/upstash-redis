import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/lrange.dart';
import 'package:upstash_redis/src/commands/rpush.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('lrange test', () {
    test('returns the correct range', () async {
      final key = newKey();
      final value1 = randomID();
      final value2 = randomID();
      final value3 = randomID();
      await RPushCommand(key, [value1, value2, value3]).exec(client);
      final res = await LRangeCommand<String>(key, 1, 2).exec(client);
      expect(res.length, 2);
      expect(res.first, value2);
      expect(res.last, value3);
    });
  });
}
