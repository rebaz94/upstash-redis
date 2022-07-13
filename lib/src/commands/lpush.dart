import 'package:upstash_redis/src/commands/command.dart';

class LPushCommand<TData> extends Command<int, int> {
  LPushCommand._(super.command, super.opts);

  factory LPushCommand(
    String key,
    List<TData> elements, [
    CommandOption<int, int>? opts,
  ]) {
    return LPushCommand._(['lpush', key, ...elements], opts);
  }
}
