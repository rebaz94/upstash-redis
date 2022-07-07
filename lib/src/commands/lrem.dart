import 'package:upstash_redis/src/commands/command.dart';

class LRemCommand<TData> extends Command<int, int> {
  LRemCommand._(super.command, super.opts);

  factory LRemCommand(
    String key,
    int count,
    TData value, [
    CommandOption<int, int>? opts,
  ]) {
    return LRemCommand._(['lrem', key, count, value], opts);
  }
}
