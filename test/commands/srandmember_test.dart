import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/spop.dart';
import 'package:upstash_redis/src/commands/srandmember.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('srandmember test', () {
    test('without opts, returns a random key', () async {
      final key = newKey();
      final member = randomID();
      await SAddCommand(key, [member]).exec(client);
      final res = await SRandMemberCommand<String>(key).exec(client);
      expect(res, member);
    });

    test('with count, returns the random n elements', () async {
      final key = newKey();
      final members = [randomID(), randomID()];
      await SAddCommand(key, members).exec(client);
      final res = await SPopCommand<List<String>>(key, 2).exec(client);
      expect(res?.length, 2);
    });
  });
}
