import 'package:upstash_redis/src/commands/command.dart';

class HSetNXCommand<TData> extends Command<int, int> {
  HSetNXCommand._(super.command, super.opts);

  factory HSetNXCommand(
    String key,
    String field,
    TData value, [
    CommandOption<int, int>? opts,
  ]) {
    return HSetNXCommand._(['hsetnx', key, field, value], opts);
  }
}
