import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/evalsha.dart';
import 'package:upstash_redis/src/commands/script_load.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();

  tearDownAll(() => keygen.cleanup());

  test('without keys, returns something', () async {
    final value = randomID();
    final sha1 =
        await ScriptLoadCommand('return {ARGV[1], "$value"}').exec(client);
    final res = await EvalshaCommand(sha1, [], [value]).exec(client);
    expect(res, [value, value]);
  });
}
