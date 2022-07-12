import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/get.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/commands/setnx.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('setnx test', () {
    test('sets value', () async {
      final key = newKey();
      final value = randomID();
      final newValue = randomID();

      final res = await SetCommand(key, value).exec(client);
      expect(res, 'OK');

      final res2 = await SetNxCommand(key, newValue).exec(client);
      expect(res2, 0);

      final res3 = await GetCommand(key).exec(client);
      expect(res3, value);
    });
  });
}
