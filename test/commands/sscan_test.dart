import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/sadd.dart';
import 'package:upstash_redis/src/commands/sscan.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  group('sscan test', () {
    test('without options, returns cursor and members', () async {
      final key = newKey();
      final member = randomID();
      await SAddCommand(key, [member]).exec(client);
      final res = await SScanCommand(key, 0).exec(client);

      expect(res.length, 2);
      expect(res.first.runtimeType, int);
      expect(res.last.runtimeType, List<String>);
      expect((res.last as List<String>).isNotEmpty, true);
    });

    test('with match, returns cursor and members', () async {
      final key = newKey();
      final member = randomID();
      await SAddCommand(key, [member]).exec(client);
      final res = await SScanCommand(key, 0, match: member).exec(client);

      expect(res.length, 2);
      expect(res.first.runtimeType, int);
      expect(res.last.runtimeType, List<String>);
      expect((res.last as List<String>).isNotEmpty, true);
    });

    test('with count, returns cursor and member', () async {
      final key = newKey();
      final member = randomID();
      await SAddCommand(key, [member]).exec(client);
      final res = await SScanCommand(key, 0, count: 1).exec(client);

      expect(res.length, 2);
      expect(res.first.runtimeType, int);
      expect(res.last.runtimeType, List<String>);
      expect((res.last as List<String>).isNotEmpty, true);
    });
  });
}
