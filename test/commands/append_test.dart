import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/append.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('when key is not set, appends to empty value', () async {
    final key = newKey();
    final value = randomID();
    final res = await AppendCommand(key, value).exec(client);
    expect(res, value.length);
  });

  test('when key is set, appends to existing value', () async {
    final key = newKey();
    final value = randomID();
    final res = await AppendCommand(key, value).exec(client);
    expect(res, value.length);
    final res2 = await AppendCommand(key, '_').exec(client);
    expect(res2, value.length + 1);
  });
}
