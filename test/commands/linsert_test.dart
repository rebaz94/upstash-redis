import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/linsert.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('linsert test', () {
    test('adds the element', () async {
      final key = newKey();
      final value1 = randomID();
      final value2 = randomID();
      await LPushCommand(key, [value1, value2]).exec(client);

      final res = await LInsertCommand(key, IDirection.before, value1, value2)
          .exec(client);
      expect(res, 3);
    });
  });
}
