import 'package:upstash_redis/src/commands/command.dart';

class ZRemRangeByScoreCommand extends Command<int, int> {
  ZRemRangeByScoreCommand._(super.command, super.opts);

  factory ZRemRangeByScoreCommand(
    String key,
    int min,
    int max, [
    CommandOption<int, int>? opts,
  ]) {
    return ZRemRangeByScoreCommand._(['zremrangebyscore', key, min, max], opts);
  }
}
