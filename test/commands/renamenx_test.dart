import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/renamenx.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('renamenx test', () {
    test('when the key exists, does nothing', () async {
      final source = newKey();
      final destination = newKey();
      final sourceValue = randomID();
      final destinationValue = randomID();
      await SetCommand(source, sourceValue).exec(client);
      await SetCommand(destination, destinationValue).exec(client);
      final res = await RenameNXCommand(source, destination).exec(client);
      expect(res, 0);
    });

    test('when the key does not exist, renames the key', () async {
      final source = newKey();
      final destination = newKey();
      final value = randomID();
      await SetCommand(source, value).exec(client);
      final res = await RenameNXCommand(source, destination).exec(client);
      expect(res, 1);
    });
  });
}
