import 'package:upstash_redis/src/commands/command.dart';

class LRangeCommand<TData> extends Command<List<String?>, List<TData>> {
  LRangeCommand._(super.command, super.opts);

  factory LRangeCommand(
    String key,
    int start,
    int end, [
    CommandOption<List<String?>, List<TData>>? opts,
  ]) {
    return LRangeCommand._(['lrange', key, start, end], opts);
  }
}
