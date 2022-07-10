import 'package:upstash_redis/src/commands/command.dart';

class PTtlCommand<TData> extends Command<int, int> {
  PTtlCommand._(super.command, super.opts);

  factory PTtlCommand(String key, [CommandOption<int, int>? opts]) {
    return PTtlCommand._(['pttl', key], opts);
  }
}
