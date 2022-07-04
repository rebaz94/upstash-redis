import 'package:upstash_redis/src/commands/command.dart';

class ZRemCommand<TData> extends Command<int, int> {
  ZRemCommand._(super.command, super.opts);

  factory ZRemCommand(
    String key,
    List<TData> members, [
    CommandOption<int, int>? opts,
  ]) {
    return ZRemCommand._(['zrem', key, ...members], opts);
  }
}
