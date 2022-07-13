import 'package:upstash_redis/src/commands/command.dart';

class ZLexCountCommand extends Command<int, int> {
  ZLexCountCommand._(super.command, super.opts);

  factory ZLexCountCommand(
    String key,
    String min,
    String max, [
    CommandOption<int, int>? opts,
  ]) {
    return ZLexCountCommand._(['zlexcount', key, min, max], opts);
  }
}
