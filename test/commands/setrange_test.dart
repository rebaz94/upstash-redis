import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/get.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/commands/setrange.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('setrange test', () {
    test('sets value', () async {
      final key = newKey();
      final value = 'originalValue';

      final res = await SetCommand(key, value).exec(client);
      expect(res, 'OK');

      final res2 = await SetRangeCommand(key, 4, 'helloWorld').exec(client);
      expect(res2, 14);

      final res3 = await GetCommand(key).exec(client);
      expect(res3, 'orighelloWorld');
    });
  });
}
