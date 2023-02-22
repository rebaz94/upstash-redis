import 'package:upstash_redis/src/commands/command.dart';

enum LMoveDir {
  left('left'),
  right('right');

  const LMoveDir(this.value);

  final String value;
}

class LMoveCommand<TData> extends Command<TData, TData> {
  LMoveCommand._(super.command, super.opts);

  factory LMoveCommand(
    String source,
    String destination, {
    required LMoveDir whereFrom,
    required LMoveDir whereTo,
    CommandOption<TData, TData>? opts,
  }) {
    return LMoveCommand._([
      'lmove',
      source,
      destination,
      whereFrom.value,
      whereTo.value,
    ], opts);
  }
}
