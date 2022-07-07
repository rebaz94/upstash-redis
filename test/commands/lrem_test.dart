import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/commands/lrem.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('lrem test', () {
    test('returns the number of deleted elements', () async {
      final key = newKey();
      await LPushCommand(key, ['element']).exec(client);
      await LPushCommand(key, ['element']).exec(client);
      await LPushCommand(key, ['element']).exec(client);

      final res = await LRemCommand(key, 2, 'element').exec(client);
      expect(res, 2);
    });
  });
}
