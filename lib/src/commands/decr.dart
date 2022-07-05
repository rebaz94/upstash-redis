import 'package:upstash_redis/src/commands/command.dart';

class DecrCommand extends Command<int, int> {
  DecrCommand._(super.command, super.opts);

  factory DecrCommand(String key, [CommandOption<int, int>? opts]) {
    return DecrCommand._(['decr', key], opts);
  }
}
