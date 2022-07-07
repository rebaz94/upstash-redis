import 'package:upstash_redis/src/commands/command.dart';

class LPopCommand<TData> extends Command<Object?, TData?> {
  LPopCommand._(super.command, super.opts);

  factory LPopCommand(String key, [CommandOption<Object?, TData?>? opts]) {
    return LPopCommand._(['lpop', key], opts);
  }
}
