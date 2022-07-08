import 'package:upstash_redis/src/commands/command.dart';

class HValsCommand<TData> extends Command<List<TData>, List<TData>> {
  HValsCommand._(super.command, super.opts);

  factory HValsCommand(String key, [CommandOption<List<TData>, List<TData>>? opts]) {
    return HValsCommand._(['hvals', key], opts);
  }
}
