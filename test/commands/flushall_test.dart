import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/mod.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();

  tearDownAll(() => keygen.cleanup());

  test('without options, flushes the db', () async {
    final res = await FlushAllCommand().exec(client);
    expect(res, 'OK');
  });

  test('with options, flushes the db', () async {
    final res = await FlushAllCommand(async: true).exec(client);
    expect(res, 'OK');
  });
}
