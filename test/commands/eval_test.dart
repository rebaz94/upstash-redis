import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/eval.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('without keys, returns something', () async {
    final value = randomID();
    final res = await EvalCommand('return ARGV[1]', [], [value]).exec(client);
    expect(res, value);
  });

  test('with keys keys, returns something', () async {
    final key = newKey();
    final value = randomID();
    await SetCommand(key, value).exec(client);
    final res = await EvalCommand('return redis.call("GET", KEYS[1])', [key]).exec(client);
    expect(res, value);
  });

}
