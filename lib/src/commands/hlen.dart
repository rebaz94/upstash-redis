import 'package:upstash_redis/src/commands/command.dart';

class HLenCommand extends Command<int, int> {
  HLenCommand._(super.command, super.opts);

  factory HLenCommand(String key, [CommandOption<int, int>? opts]) {
    return HLenCommand._(['hlen', key], opts);
  }
}
