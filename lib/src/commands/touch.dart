import 'package:upstash_redis/src/commands/command.dart';

class TouchCommand extends Command<int, int> {
  TouchCommand._(super.command, super.opts);

  factory TouchCommand(List<String> keys, [CommandOption<int, int>? opts]) {
    return TouchCommand._(['touch', ...keys], opts);
  }
}
