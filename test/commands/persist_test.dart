import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/get.dart';
import 'package:upstash_redis/src/commands/persist.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('persist test', () {
    test('persists the key', () async {
      final key = newKey();
      final value = randomID();
      await SetCommand(key, value, ex: 2).exec(client);
      final res = await PersistCommand(key).exec(client);
      expect(res, 1);

      await Future.delayed(const Duration(seconds: 2));
      final res2 = await GetCommand<String>(key).exec(client);
      expect(res2, value);
    });
  });
}
