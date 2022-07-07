import 'package:upstash_redis/src/commands/command.dart';

class IncrCommand extends Command<int, int> {
  IncrCommand._(super.command, super.opts);

  factory IncrCommand(String key, [CommandOption<int, int>? opts]) {
    return IncrCommand._(['incr', key], opts);
  }
}
