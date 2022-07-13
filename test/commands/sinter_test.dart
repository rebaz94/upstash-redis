import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/sinter.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('sinter', () {
    test('with single set, returns the members of the set', () async {
      final key = newKey();
      final value1 = {'v': randomID()};
      final value2 = {'v': randomID()};

      await SAddCommand(key, [value1, value2]).exec(client);
      final res = await SInterCommand<Map<String, String>>([key]).exec(client);
      final allValues = res.map((e) => e.values.toList()).flattened.toList();

      expect(res.length, 2);
      expect(allValues, contains(value1['v']));
      expect(allValues, contains(value2['v']));
    });

    test('with multiple set, returns the members of the set', () async {
      final key1 = newKey();
      final key2 = newKey();
      final value1 = {'v': randomID()};
      final value2 = {'v': randomID()};
      final value3 = {'v': randomID()};

      await SAddCommand(key1, [value1, value2]).exec(client);
      await SAddCommand(key2, [value2, value3]).exec(client);
      final res =
          await SInterCommand<Map<String, String>>([key1, key2]).exec(client);
      expect(res, [value2]);
    });
  });
}
