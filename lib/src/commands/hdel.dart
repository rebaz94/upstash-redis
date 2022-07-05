import 'package:upstash_redis/src/commands/command.dart';

class HDelCommand extends Command<int, int> {
  HDelCommand._(super.command, super.opts);

  factory HDelCommand(String key, String field, [CommandOption<int, int>? opts]) {
    return HDelCommand._(['hdel', key, field], opts);
  }
}
