import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/bitop.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('when key is not set, returns 0', () async {
    final source = newKey();
    final dest = newKey();
    final res = await BitOpCommand(BitOp.and, dest, [source]).exec(client);
    expect(res, 0);
  });

  group('when key is set', () {
    test('not, inverts all bits', () async {
      final source = newKey();
      final sourceValue = 'Hello World';
      final dest = newKey();
      final destValue = 'foo: bar';
      await SetCommand(source, sourceValue).exec(client);
      await SetCommand(dest, destValue).exec(client);
      final res = await BitOpCommand(BitOp.not, dest, [source]).exec(client);
      expect(res, 11);
    });

    test('and, works', () async {
      final source = newKey();
      final sourceValue = 'Hello World';
      final dest = newKey();
      final destValue = 'foo: bar';
      await SetCommand(source, sourceValue).exec(client);
      await SetCommand(dest, destValue).exec(client);
      final res = await BitOpCommand(BitOp.and, dest, [source]).exec(client);
      expect(res, 11);
    });
  });
}
