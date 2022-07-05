import 'package:upstash_redis/src/commands/command.dart';

class HGetCommand<TData> extends Command<Object?, TData?> {
  HGetCommand._(super.command, super.opts);

  factory HGetCommand(String key, String field, [CommandOption<Object?, TData?>? opts]) {
    return HGetCommand._(['hget', key, field], opts);
  }
}
