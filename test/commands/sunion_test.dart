import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/sunion.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('sunion test', () {
    test('returns the union', () async {
      final key1 = newKey();
      final key2 = newKey();
      final member1 = randomID();
      final member2 = randomID();
      await SAddCommand(key1, [member1]).exec(client);
      await SAddCommand(key2, [member2]).exec(client);
      final res = await SUnionCommand<String>([key1, key2]).exec(client);

      expect(res..sort(), [member1, member2]..sort());
    });
  });
}
