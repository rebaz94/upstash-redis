import 'package:upstash_redis/src/commands/command.dart';

class StrLenCommand extends Command<int, int> {
  StrLenCommand._(super.command, super.opts);

  factory StrLenCommand(
    String key, [
    CommandOption<int, int>? opts,
  ]) {
    return StrLenCommand._(['strlen', key], opts);
  }
}
