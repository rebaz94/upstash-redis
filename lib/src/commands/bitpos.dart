import 'package:upstash_redis/src/commands/command.dart';

class BitPosCommand extends Command<int, int> {
  BitPosCommand._(super.command, super.opts);

  factory BitPosCommand(
    String key,
    int start, [
    int? end,
    CommandOption<int, int>? opts,
  ]) {
    return BitPosCommand._(['bitpos', key, start, if (end != null) end], opts);
  }
}
