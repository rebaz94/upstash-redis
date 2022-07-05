import 'package:upstash_redis/src/commands/command.dart';

enum BitOp {
  and,
  or,
  xor,
  not,
}

class BitOpCommand extends Command<int, int> {
  BitOpCommand._(super.command, super.opts);

  factory BitOpCommand(
    BitOp op,
    String destinationKey,
    List<String> sourceKeys, [
    CommandOption<int, int>? opts,
  ]) {
    if (op == BitOp.not && sourceKeys.length > 1) {
      throw StateError(
        '`not` operation is only takes an input only, but it takes ${sourceKeys.length}',
      );
    }
    return BitOpCommand._(['bitop', 'and', destinationKey, ...sourceKeys], opts);
  }

  factory BitOpCommand.and(
    String destinationKey,
    List<String> sourceKeys, [
    CommandOption<int, int>? opts,
  ]) {
    assert(sourceKeys.isNotEmpty, 'sourceKeys must have at least one key');
    return BitOpCommand._(['bitop', 'and', destinationKey, ...sourceKeys], opts);
  }

  factory BitOpCommand.or(
    String destinationKey,
    List<String> sourceKeys, [
    CommandOption<int, int>? opts,
  ]) {
    assert(sourceKeys.isNotEmpty, 'sourceKeys must have at least one key');
    return BitOpCommand._(['bitop', 'or', destinationKey, ...sourceKeys], opts);
  }

  factory BitOpCommand.xor(
    String destinationKey,
    List<String> sourceKeys, [
    CommandOption<int, int>? opts,
  ]) {
    assert(sourceKeys.isNotEmpty, 'sourceKeys must have at least one key');
    return BitOpCommand._(['bitop', 'xor', destinationKey, ...sourceKeys], opts);
  }

  factory BitOpCommand.not(
    String destinationKey,
    String sourceKey, [
    CommandOption<int, int>? opts,
  ]) {
    return BitOpCommand._(['bitop', 'not', destinationKey, sourceKey], opts);
  }
}
