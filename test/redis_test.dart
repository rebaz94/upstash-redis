import 'package:test/test.dart';
import 'package:upstash_redis/src/test_utils.dart';
import 'package:upstash_redis/upstash_redis.dart';

void main() {
  final client = newHttpClient(useBase64: true);
  final keygen = Keygen();
  final newKey = keygen.newKey;

  group('when storing base64 data', () {
    test('general', () async {
      final redis = Redis.byClient(client);
      final key = newKey();
      final value = "VXBzdGFzaCBpcyByZWFsbHkgY29vbA";
      await redis.set(key, value);
      final res = await redis.get(key);
      expect(res, value);
    });

    // decode("OK") => 8
    test("getting '8'", () async {
      final redis = Redis.byClient(client);
      final key = newKey();
      final value = 8;
      await redis.set(key, value);
      final res = await redis.get<int>(key);
      expect(res, value);
    });

    test("getting 'OK'", () async {
      final redis = Redis.byClient(client);
      final key = newKey();
      final value = 'OK';
      await redis.set(key, value);
      final res = await redis.get(key);
      expect(res, value);
    });
  });

  test('zadd, adds the set', () async {
    final redis = Redis.byClient(client);
    final key = newKey();
    final res = await redis.zadd(key, score: 1, member: randomID());
    expect(res, 1);
  });

  test('zrange, returns the range', () async {
    final redis = Redis.byClient(client);
    final key = newKey();
    final member = randomID();
    await redis.zadd(key, score: 1, member: member);
    final res = await redis.zrange(key, 0, 2);
    expect(res, [member]);
  });

  group('bad data', () {
    test('with encodeURIComponent', () async {
      final redis = Redis.byClient(client);
      final key = newKey();
      final value = "😀";
      await redis.set(key, Uri.encodeComponent(value));
      final res = await redis.get<String>(key);
      expect(Uri.decodeComponent(res ?? ''), value);
    });

    test('emojis', () async {
      final redis = Redis.byClient(client);
      final key = newKey();
      final value = "😀";
      await redis.set(key, value);
      final res = await redis.get<String>(key);
      expect(res, value);
    });
  });
}
