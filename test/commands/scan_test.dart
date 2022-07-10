import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/scan.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('without options, returns cursor and keys', () async {
    final key = newKey();
    final value = randomID();
    await SetCommand(key, value).exec(client);
    final res = await ScanCommand(0).exec(client);

    expect(res.length, 2);
    expect(res.first.runtimeType, int);
    expect(res.last.runtimeType, List<String>);
    expect((res.last as List<String>).isNotEmpty, true);
  });

  test('with match, returns cursor and keys', () async {
    final key = newKey();
    final value = randomID();
    await SetCommand(key, value).exec(client);
    final res = await ScanCommand(0, match: key).exec(client);

    expect(res.length, 2);
    expect(res.first.runtimeType, int);
    expect(res.last.runtimeType, List<String>);
    expect((res.last as List<String>).isNotEmpty, true);
  });

  test('with count, returns cursor and keys', () async {
    final key = newKey();
    final value = randomID();
    await SetCommand(key, value).exec(client);
    final res = await ScanCommand(0, count: 1).exec(client);

    expect(res.length, 2);
    expect(res.first.runtimeType, int);
    expect(res.last.runtimeType, List<String>);
    expect((res.last as List<String>).isNotEmpty, true);
  });
}
