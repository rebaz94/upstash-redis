import 'package:upstash_redis/src/commands/command.dart';

class GetBitCommand extends Command<int, int> {
  GetBitCommand._(super.command, super.opts);

  factory GetBitCommand(
    String key,
    int offset, [
    CommandOption<int, int>? opts,
  ]) {
    return GetBitCommand._(['getbit', key, offset], opts);
  }
}
