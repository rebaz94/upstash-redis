import 'package:upstash_redis/src/commands/command.dart';

class ZCardCommand extends Command<int, int> {
  ZCardCommand._(super.command, super.opts);

  factory ZCardCommand(String key, [CommandOption<int, int>? opts]) {
    return ZCardCommand._(['zcard', key], opts);
  }
}
