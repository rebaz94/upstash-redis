import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/commands/ltrim.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('ltrim test', () {
    test('when the list exists, returns ok', () async {
      final key = newKey();
      await LPushCommand(key, [randomID()]).exec(client);
      await LPushCommand(key, [randomID()]).exec(client);
      await LPushCommand(key, [randomID()]).exec(client);
      final res = await LTrimCommand(key, 1, 2).exec(client);
      expect(res, 'OK');
    });

    test('when the list does not exist, returns ok', () async {
      final key = newKey();
      final res = await LTrimCommand(key, 1, 2).exec(client);
      expect(res, 'OK');
    });
  });
}
