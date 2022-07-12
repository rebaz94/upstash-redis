import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/sismember.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('sismember test', () {
    test('when member exists, returns 1', () async {
      final key = newKey();
      final value = randomID();
      await SAddCommand(key, [value]).exec(client);
      final res = await SIsMemberCommand(key, value).exec(client);
      expect(res, 1);
    });

    test('when member not exists, returns 0', () async {
      final key = newKey();
      final value1 = randomID();
      final value2 = randomID();
      await SAddCommand(key, [value1]).exec(client);
      final res = await SIsMemberCommand(key, value2).exec(client);
      expect(res, 0);
    });
  });
}
