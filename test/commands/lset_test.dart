import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/lpop.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/commands/lset.dart';
import 'package:upstash_redis/src/test_utils.dart';
import 'package:upstash_redis/src/upstash_error.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('lset test', () {
    group('when list exists and the index is in range', () {
      test('replaces the element at index', () async {
        final key = newKey();
        final value = randomID();
        final newValue = randomID();
        await LPushCommand(key, [value]).exec(client);
        final res = await LSetCommand(key, 0, newValue).exec(client);
        expect(res, 'OK');

        final res2 = await LPopCommand(key).exec(client);
        expect(res2, newValue);
      });

      test('when the index is out of bounds, returns null', () async {
        final key = newKey();
        final value = randomID();
        final newValue = randomID();
        await LPushCommand(key, [value]).exec(client);

        expect(
          LSetCommand(key, 1, newValue).exec(client),
          throwsA(TypeMatcher<UpstashError>()),
        );
      });
    });
  });
}
