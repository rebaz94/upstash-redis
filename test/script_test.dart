import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:test/test.dart';
import 'package:upstash_redis/src/test_utils.dart';
import 'package:upstash_redis/upstash_redis.dart';

void main() {
  final client = newHttpClient();
  final keygen = Keygen();

  computeSha1(String script) => sha1.convert(utf8.encode(script)).toString();

  tearDown(() async => await keygen.cleanup());

  test('create a new script', () async {
    final redis = Redis.byClient(client);
    final scriptSource = 'return ARGV[1];';
    final script = redis.createScript(scriptSource, computeSha1(scriptSource));

    final res = await script.eval([], ['Hello World']);
    expect(res, 'Hello World');
  });

  group('sha1', () {
    test('calculates the correct sha1', () async {
      final redis = Redis.byClient(client);
      final scriptSource = 'The quick brown fox jumps over the lazy dog';
      final script =
          redis.createScript(scriptSource, computeSha1(scriptSource));
      expect(script.sha1, '2fd4e1c67a2d28fced849ee1bb76e7391b93eb12');
    });

    test('calculates the correct sha1 for empty string', () async {
      final redis = Redis.byClient(client);
      final scriptSource = '';
      final script =
          redis.createScript(scriptSource, computeSha1(scriptSource));
      expect(script.sha1, 'da39a3ee5e6b4b0d3255bfef95601890afd80709');
    });
  });

  group('script gets loaded', () {
    test('following evalsha command is a hit', () async {
      final id = randomID();
      final scriptSource = 'return "$id";';
      final redis = Redis.byClient(client);
      final script =
          redis.createScript<String>(scriptSource, computeSha1(scriptSource));

      expect(script.evalsha([], []), throwsA(anything));
      final res = await script.exec([], []);
      expect(res, id);

      final res2 = await script.evalsha([], []);
      expect(res2, id);
    });
  });
}
