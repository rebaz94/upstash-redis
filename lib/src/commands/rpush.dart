import 'package:upstash_redis/src/commands/command.dart';

class RPushCommand<TData> extends Command<int, int> {
  RPushCommand._(super.command, super.opts);

  factory RPushCommand(
    String key,
    List<TData> elements, [
    CommandOption<int, int>? opts,
  ]) {
    return RPushCommand._(['rpush', key, ...elements], opts);
  }
}
