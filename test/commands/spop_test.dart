import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/spop.dart';
import 'package:upstash_redis/src/test_utils.dart';
import 'package:collection/collection.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('spop test', () {
    test('without count, returns random element', () async {
      final key = newKey();
      final member = randomID();
      await SAddCommand(key, [member]).exec(client);
      final res = await SPopCommand<String>(key).exec(client);
      expect(res, member);
    });

    test('with count, returns the random n elements', () async {
      final key = newKey();
      final members = [randomID(), randomID(), randomID(), randomID()];
      await SAddCommand(key, members).exec(client);
      final res = await SPopCommand<List<String>>(key, 2).exec(client);
      expect(res?.length, 2);
      expect(members, contains(res?.firstOrNull));
      expect(members, contains(res?[1]));
    });
  });
}
