import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/smove.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('smove test', () {
    test('moves the member', () async {
      final source = newKey();
      final destination = newKey();
      final member = randomID();
      await SAddCommand(source, [member]).exec(client);
      final res = await SMoveCommand(source, destination, member).exec(client);
      expect(res, 1);
    });
  });
}
