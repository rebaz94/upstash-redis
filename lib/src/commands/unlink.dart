import 'package:upstash_redis/src/commands/command.dart';

class UnlinkCommand extends Command<int, int> {
  UnlinkCommand._(super.command, super.opts);

  factory UnlinkCommand(List<String> keys, [CommandOption<int, int>? opts]) {
    return UnlinkCommand._(['unlink', ...keys], opts);
  }
}
