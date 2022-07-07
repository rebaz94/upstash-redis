import 'package:upstash_redis/src/commands/command.dart';

class RPopCommand<TData> extends Command<Object?, TData?> {
  RPopCommand._(super.command, super.opts);

  factory RPopCommand(String key, [CommandOption<Object?, TData?>? opts]) {
    return RPopCommand._(['rpop', key], opts);
  }
}
