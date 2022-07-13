import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class SetRangeCommand extends Command<int, int> {
  SetRangeCommand._(super.command, super.opts);

  factory SetRangeCommand(
    String key,
    int offset,
    String value, [
    CommandOption<int, int>? opts,
  ]) {
    return SetRangeCommand._(['setrange', key, offset, value], opts);
  }
}
