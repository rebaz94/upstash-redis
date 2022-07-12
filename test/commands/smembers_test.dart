import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/smembers.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('smembers test', () {
    test('returns all members of the set', () async {
      final key = newKey();
      final value1 = {'v': randomID()};
      final value2 = {'v': randomID()};
      await SAddCommand(key, [value1, value2]).exec(client);
      final res = await SMembersCommand<Map<String, String>>(key).exec(client);
      final resValues = res.map((e) => e.values).flattened.toList();

      expect(res.length, 2);
      expect(resValues, contains(value1['v']));
      expect(resValues, contains(value2['v']));
    });
  });
}
