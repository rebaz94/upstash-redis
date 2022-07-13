import 'package:upstash_redis/src/commands/command.dart';

class HStrLenCommand extends Command<int, int> {
  HStrLenCommand._(super.command, super.opts);

  factory HStrLenCommand(
    String key,
    String field, [
    CommandOption<int, int>? opts,
  ]) {
    return HStrLenCommand._(['hstrlen', key, field], opts);
  }
}
