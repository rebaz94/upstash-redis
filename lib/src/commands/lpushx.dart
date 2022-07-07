import 'package:upstash_redis/src/commands/command.dart';

  class LPushXCommand<TData> extends Command<int, int> {
  LPushXCommand._(super.command, super.opts);

  factory LPushXCommand(String key, List<TData> elements, [CommandOption<int, int>? opts]) {
    return LPushXCommand._(['lpushx', key, ...elements], opts);
  }
}
