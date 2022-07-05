import 'package:upstash_redis/src/commands/command.dart';

class SetBitCommand extends Command<int, int> {
  SetBitCommand._(super.command, super.opts);

  factory SetBitCommand(
    String key,
    int offset,
    int bit, [
    CommandOption<int, int>? opts,
  ]) {
    if (bit < 0 || bit > 1) {
      throw StateError('bit should be 0 or 1');
    }
    return SetBitCommand._(['setbit', key, offset, bit], opts);
  }
}
