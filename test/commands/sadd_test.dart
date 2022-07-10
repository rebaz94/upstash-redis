import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('sadd test', () {
    test('returns the number of added members', () async {
      final key = newKey();
      final value1 = randomID();
      final value2 = randomID();
      final res = await SAddCommand(key, [value1, value2]).exec(client);
      expect(res, 2);
    });
  });
}
