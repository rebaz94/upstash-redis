import 'package:upstash_redis/src/commands/command.dart';

class LIndexCommand<TData> extends Command<Object?, TData?> {
  LIndexCommand._(super.command, super.opts);

  factory LIndexCommand(String key, int index, [CommandOption<Object?, TData?>? opts]) {
    return LIndexCommand._(['lindex', key, index], opts);
  }
}
