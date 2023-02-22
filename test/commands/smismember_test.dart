import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/smismember.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('when member exists, returns 1', () async {
    final key = newKey();
    final value1 = randomID();
    final value2 = randomID();
    await SAddCommand(key, [value1]).exec(client);
    await SAddCommand(key, [value2]).exec(client);
    final res = await SMIsMemberCommand(key, [value1, randomID()]).exec(client);
    expect(res, [1, 0]);
  });
}
