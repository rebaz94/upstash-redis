import 'package:upstash_redis/src/commands/command.dart';

class RPushXCommand<TData> extends Command<int, int> {
  RPushXCommand._(super.command, super.opts);

  factory RPushXCommand(
    String key,
    List<TData> elements, [
    CommandOption<int, int>? opts,
  ]) {
    return RPushXCommand._(['rpushx', key, ...elements], opts);
  }
}
