import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/publish.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();

  tearDownAll(() => keygen.cleanup());

  group('publish test', () {
    test('returns the number of clients that received the message', () async {
      final res = await PublishCommand("channel", "hello").exec(client);
      expect(res.runtimeType, int);
    });
  });
}
