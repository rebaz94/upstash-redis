import 'package:test/test.dart';
import 'package:upstash_redis/src/http.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() {
  test('remove trailing slash from urls', () {
    final client = UpstashHttpClient(
      HttpClientConfig(baseUrl: 'https://example.com/'),
    );

    expect(client.baseUrl, 'https://example.com');
  });

  test('throw when the request is invalid', () {
    final client = newHttpClient();
    expect(client.request(body: ['get', '1', '2']), throwsException);
  });
  test('throw without authorization', () {
    final client = newHttpClient();
    client.headers.clear();
    expect(client.request(body: ['get', '1', '2']), throwsException);
  });
}
