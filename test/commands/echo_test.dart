import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/mod.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();

  tearDownAll(() => keygen.cleanup());

  test('returns the message', () async {
    final message = randomID();
    final res = await EchoCommand(message).exec(client);
    expect(res, message);
  });
}
