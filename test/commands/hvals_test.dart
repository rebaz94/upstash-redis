import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/commands/hvals.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('hvals command', () {
    test('returns correct length', () async {
      final key = newKey();
      final field = randomID();
      final value = randomID();

      final res = await HValsCommand<String>(key).exec(client);
      expect(res, []);

      await HSetCommand(key, {field: value}).exec(client);
      final res2 = await HValsCommand<String>(key).exec(client);
      expect(res2, [value]);
    });
  });
}
