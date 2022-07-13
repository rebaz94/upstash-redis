import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/rpush.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('rpush test', () {
    test('returns the length after command', () async {
      final key = newKey();
      final res = await RPushCommand(key, [randomID()]).exec(client);
      expect(res, 1);

      final res2 =
          await RPushCommand(key, [randomID(), randomID()]).exec(client);
      expect(res2, 3);
    });
  });
}
