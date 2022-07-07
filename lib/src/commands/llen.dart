import 'package:upstash_redis/src/commands/command.dart';

class LLenCommand<TData> extends Command<int, int> {
  LLenCommand._(super.command, super.opts);

  factory LLenCommand(String key, [CommandOption<int, int>? opts]) {
    return LLenCommand._(['llen', key], opts);
  }
}
