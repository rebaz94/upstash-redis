import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/ping.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();

  tearDownAll(() => keygen.cleanup());

  group('ping test', () {
    test('with message, returns the message', () async {
      final message = randomID();
      final res = await PingCommand(message).exec(client);
      expect(res, message);
    });

    test('without message, returns pong', () async {
      final res = await PingCommand().exec(client);
      expect(res, 'PONG');
    });
  });
}
