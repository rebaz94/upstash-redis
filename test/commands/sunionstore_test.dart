import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/smembers.dart';
import 'package:upstash_redis/src/commands/sunionstore.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('sunionstore test', () {
    test('writes the union to destination', () async {
      final key1 = newKey();
      final key2 = newKey();
      final dest = newKey();
      final member1 = randomID();
      final member2 = randomID();

      await SAddCommand(key1, [member1]).exec(client);
      await SAddCommand(key2, [member2]).exec(client);
      final res = await SUnionStoreCommand(dest, [key1, key2]).exec(client);
      expect(res, 2);

      final res2 = await SMembersCommand<String>(dest).exec(client);
      expect(res2, isNotEmpty);
      expect(res2..sort(), [member1, member2]..sort());
    });
  });
}
