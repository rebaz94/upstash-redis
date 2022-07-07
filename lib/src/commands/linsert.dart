import 'package:upstash_redis/src/commands/command.dart';

enum IDirection {
  before,
  after,
}

class LInsertCommand<TData> extends Command<int, int> {
  LInsertCommand._(super.command, super.opts);

  factory LInsertCommand(
    String key,
    IDirection direction,
    TData pivot,
    TData value, [
    CommandOption<int, int>? opts,
  ]) {
    return LInsertCommand._(['linsert', key, direction.name, pivot, value], opts);
  }
}
