import 'package:upstash_redis/src/commands/command.dart';

class BitPosCommand extends Command<int, int> {
  BitPosCommand._(super.command, super.opts);

  factory BitPosCommand(
    String key,
    int bit, [
    int? start,
    int? end,
    CommandOption<int, int>? opts,
  ]) {
    if (bit > 1 || bit < 0) {
      throw StateError('`bit should be 0 or 1`');
    }
    return BitPosCommand._([
      'bitpos',
      key,
      bit,
      if (start != null) start,
      if (end != null) end,
    ], opts);
  }
}
