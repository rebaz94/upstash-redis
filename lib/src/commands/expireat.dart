import 'package:upstash_redis/src/commands/command.dart';

class ExpireAtCommand extends Command<int, int> {
  ExpireAtCommand._(super.command, super.opts);

  factory ExpireAtCommand(String key, int unix, [CommandOption<int, int>? opts]) {
    return ExpireAtCommand._(['expireat', key, unix], opts);
  }
}
