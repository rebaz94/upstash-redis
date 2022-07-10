import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/scard.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('scard', () {
    test('returns the cardinality', () async {
      final key = newKey();
      await SAddCommand(key, ['member1']).exec(client);
      final res = await SCardCommand(key).exec(client);
      expect(res, 1);
    });
  });
}
