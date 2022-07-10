import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/rename.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('rename test', () {
    test('renames the key', () async {
      final source = newKey();
      final destination = newKey();
      final value = randomID();
      await SetCommand(source, value).exec(client);
      final res = await RenameCommand(source, destination).exec(client);
      expect(res, 'OK');
    });
  });
}
