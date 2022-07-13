import 'package:upstash_redis/src/commands/command.dart';

class ZRemRangeByRankCommand extends Command<int, int> {
  ZRemRangeByRankCommand._(super.command, super.opts);

  factory ZRemRangeByRankCommand(
    String key,
    int start,
    int stop, [
    CommandOption<int, int>? opts,
  ]) {
    return ZRemRangeByRankCommand._(['zremrangebyrank', key, start, stop], opts);
  }
}
