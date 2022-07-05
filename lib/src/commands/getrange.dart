import 'package:upstash_redis/src/commands/command.dart';

class GetRangeCommand extends Command<String, String> {
  GetRangeCommand._(super.command, super.opts);

  factory GetRangeCommand(
    String key,
    int start,
    int end, [
    CommandOption<String, String>? opts,
  ]) {
    return GetRangeCommand._(['getrange', key, start, end], opts);
  }
}
