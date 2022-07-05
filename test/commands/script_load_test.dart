import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/mod.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();

  tearDownAll(() => keygen.cleanup());

  test('returns the hash', () async {
    final script = 'return ARGV[1]';
    final res = await ScripLoadCommand(script).exec(client);
    expect(res, '098e0f0d1448c0a81dafe820f66d460eb09263da');
  });
}
