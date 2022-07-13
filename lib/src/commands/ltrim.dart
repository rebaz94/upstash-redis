import 'package:upstash_redis/src/commands/command.dart';

class LTrimCommand extends Command<String, String> {
  LTrimCommand._(super.command, super.opts);

  factory LTrimCommand(
    String key,
    int start,
    int end, [
    CommandOption<String, String>? opts,
  ]) {
    return LTrimCommand._(['ltrim', key, start, end], opts);
  }
}
