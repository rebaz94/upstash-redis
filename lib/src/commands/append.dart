import 'package:upstash_redis/src/commands/command.dart';

class AppendCommand extends Command<int, int> {
  AppendCommand._(super.command, super.opts);

  factory AppendCommand(
    String key,
    String value, [
    CommandOption<int, int>? opts,
  ]) {
    return AppendCommand._(['append', key, value], opts);
  }
}
