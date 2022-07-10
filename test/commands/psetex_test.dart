import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/get.dart';
import 'package:upstash_redis/src/commands/psetex.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('psetex', () {
    test('sets value', () async {
      final key = newKey();
      final value = randomID();
      final res = await PSetEXCommand(key, 1000, value).exec(client);
      expect(res, 'OK');

      await Future.delayed(const Duration(seconds: 2));
      final res2 = await GetCommand<String>(key).exec(client);
      expect(res2, null);
    });
  });
}
