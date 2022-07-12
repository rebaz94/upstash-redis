import 'package:upstash_redis/src/commands/command.dart';

class TtlCommand extends Command<int, int> {
  TtlCommand._(super.command, super.opts);

  factory TtlCommand(String key, [CommandOption<int, int>? opts]) {
    return TtlCommand._(['ttl', key], opts);
  }
}
