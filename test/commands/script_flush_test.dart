import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/script_exists.dart';
import 'package:upstash_redis/src/commands/script_flush.dart';
import 'package:upstash_redis/src/commands/script_load.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();

  tearDownAll(() => keygen.cleanup());

  group('scriptFlush test', () {
    test('sync, flushes all scripts', () async {
      final script = 'return "${randomID()}"';
      final sha1 = await ScripLoadCommand(script).exec(client);
      expect(await ScriptExistsCommand([sha1]).exec(client), [1]);

      final res = await ScriptFlushCommand(sync: true).exec(client);
      expect(res, 'OK');
      expect(await ScriptExistsCommand([sha1]).exec(client), [0]);
    });

    test('async, flushes all scripts', () async {
      final script = 'return "${randomID()}"';
      final sha1 = await ScripLoadCommand(script).exec(client);
      expect(await ScriptExistsCommand([sha1]).exec(client), [1]);

      final res = await ScriptFlushCommand(async: true).exec(client);
      expect(res, 'OK');

      await Future.delayed(const Duration(seconds: 5));
      expect(await ScriptExistsCommand([sha1]).exec(client), [0]);
    });
  });
}
