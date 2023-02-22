import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/hrandfield.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('with single field present', () {
    test('returns the field', () async {
      final key = newKey();
      final field1 = randomID();
      final value1 = randomID();
      await HSetCommand(key, {field1: value1}).exec(client);

      final res = await HRandFieldCommand<String>(key).exec(client);
      expect(res, field1);
    });
  });

  group('with multiple fields present', () {
    test('returns a random field', () async {
      final key = newKey();
      final fields = <String, String>{};
      for (int i = 0; i < 10; i++) {
        fields[randomID()] = randomID();
      }
      await HSetCommand(key, fields).exec(client);

      final res = await HRandFieldCommand<String>(key).exec(client);
      expect(fields, contains(res));
    });
  });

  group('with withvalues', () {
    test('returns a subset with values', () async {
      final key = newKey();
      final fields = <String, String>{};
      for (int i = 0; i < 10; i++) {
        fields[randomID()] = randomID();
      }
      await HSetCommand(key, fields).exec(client);

      final res = await HRandFieldCommand<Map<String, dynamic>>(key,
              count: 2, withValues: true)
          .exec(client);
      for (final entry in res.entries) {
        expect(fields.keys, contains(entry.key));
        expect(fields[entry.key], entry.value);
      }
    });
  });

  group('when hash does not exist', () {
    test('it returns null', () async {
      final res = await HRandFieldCommand(randomID()).exec(client);
      expect(res, null);
    });
  });
}
