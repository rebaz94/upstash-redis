import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/flushdb.dart';
import 'package:upstash_redis/src/commands/scan.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/commands/type.dart';
import 'package:upstash_redis/src/commands/zadd.dart';
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

    int cursor = 0;
    final found = <String>[];
    do {
      final res = await ScanCommand(cursor).exec(client);
      expect(res.length, 2);
      expect(res.first.runtimeType, int);
      expect(res.last.runtimeType, List<String>);
      cursor = res.first;
      found.addAll(res.last);
    } while (cursor != 0);
    
    expect(found, contains(key));
  });

  test('with match, returns cursor and keys', () async {
    final key = newKey();
    final value = randomID();
    await SetCommand(key, value).exec(client);

    int cursor = 0;
    final found = <String>[];
    do {
      final res = await ScanCommand(cursor, match: key).exec(client);
      expect(res.length, 2);
      expect(res.first.runtimeType, int);
      expect(res.last.runtimeType, List<String>);
      cursor = res.first;
      found.addAll(res.last);
    } while (cursor != 0);

    expect(found, contains(key));
  });

  test('with count, returns cursor and keys', () async {
    final key = newKey();
    final value = randomID();
    await SetCommand(key, value).exec(client);

    int cursor = 0;
    final found = <String>[];
    do {
      final res = await ScanCommand(cursor, count: 1).exec(client);
      expect(res.length, 2);
      expect(res.first.runtimeType, int);
      expect(res.last.runtimeType, List<String>);
      cursor = res.first;
      found.addAll(res.last);
    } while (cursor != 0);

    expect(found, contains(key));
  });

  test('with type, returns cursor and keys', () async {
    await FlushDbCommand().exec(client);
    final key1= newKey();
    final key2= newKey();
    final value = randomID();
    await SetCommand(key1, value).exec(client);

    // Add a non-string type
    await ZAddCommand(key2, [ScoreMember(score: 1, member: 'abc')]).exec(client);

    int cursor = 0;
    final found = <String>[];
    do {
      final res = await ScanCommand(cursor, type: 'string').exec(client);
      expect(res.length, 2);
      expect(res.first.runtimeType, int);
      expect(res.last.runtimeType, List<String>);
      cursor = res.first;
      found.addAll(res.last);
    } while (cursor != 0);

    expect(found.length, 1);
    for (final key in found) {
      final type = await TypeCommand(key).exec(client);
      expect(type.value, 'string');
    }
  });
}
