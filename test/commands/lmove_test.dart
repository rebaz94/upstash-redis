import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/llen.dart';
import 'package:upstash_redis/src/commands/lmove.dart';
import 'package:upstash_redis/src/commands/lpop.dart';
import 'package:upstash_redis/src/commands/lpush.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('moves the entry from left to left', () async {
    final source = newKey();
    final destination = newKey();
    final value = randomID();
    await LPushCommand(source, [value]).exec(client);

    final res = await LMoveCommand(
      source,
      destination,
      whereFrom: LMoveDir.left,
      whereTo: LMoveDir.left,
    ).exec(client);
    expect(res, value);

    final elementInDestination = await LPopCommand(destination).exec(client);
    expect(elementInDestination, value);
  });

  test('moves the entry from left to right', () async {
    final source = newKey();
    final destination = newKey();
    final values = List.generate(5, (_) => randomID());
    await LPushCommand(source, values).exec(client);

    final res = await LMoveCommand(
      source,
      destination,
      whereFrom: LMoveDir.left,
      whereTo: LMoveDir.right,
    ).exec(client);
    expect(res, values.last);

    final elementsInSource = await LLenCommand(source).exec(client);
    expect(elementsInSource, values.length - 1);

    final elementInDestination = await LPopCommand(destination).exec(client);
    expect(elementInDestination, values.last);
  });
}
