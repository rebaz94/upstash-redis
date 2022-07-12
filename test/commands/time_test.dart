import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/time.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();

  tearDownAll(() => keygen.cleanup());

  group('time test', () {
    test('returns the time', () async {
      final res = await TimeCommand().exec(client);
      expect(res.first.runtimeType, int);
      expect(res[1].runtimeType, int);
    });
  });
}
