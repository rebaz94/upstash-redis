import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/script_exists.dart';
import 'package:upstash_redis/src/commands/script_load.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();

  tearDownAll(() => keygen.cleanup());

  group('scriptExists test', () {
    group('with a single script', () {
      test('when the script exists, returns 1', () async {
        final script = 'return "${randomID()}"';
        final hash = await ScripLoadCommand(script).exec(client);
        final res = await ScriptExistsCommand([hash]).exec(client);
        expect(res, [1]);
      });

      test('when the script does not exist, returns 0', () async {
        final res = await ScriptExistsCommand(['21']).exec(client);
        expect(res, [0]);
      });
    });

    group('with multiple scripts', () {
      test('returns the found scripts', () async {
        final script1 = 'return "${randomID()}"';
        final script2 = 'return "${randomID()}"';
        final hash1 = await ScripLoadCommand(script1).exec(client);
        final hash2 = await ScripLoadCommand(script2).exec(client);
        final res = await ScriptExistsCommand([hash1, hash2]).exec(client);
        expect(res, [1, 1]);
      });
    });
  });
}
