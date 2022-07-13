import 'package:upstash_redis/src/commands/command.dart';

class ZRemRangeByLexCommand extends Command<int, int> {
  ZRemRangeByLexCommand._(super.command, super.opts);

  factory ZRemRangeByLexCommand(
    String key,
    String min,
    String max, [
    CommandOption<int, int>? opts,
  ]) {
    return ZRemRangeByLexCommand._(['zremrangebylex', key, min, max], opts);
  }
}
