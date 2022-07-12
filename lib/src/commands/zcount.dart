import 'package:upstash_redis/src/commands/command.dart';

class ZCountCommand extends Command<int, int> {
  ZCountCommand._(super.command, super.opts);

  factory ZCountCommand(String key, Object min, Object max, [CommandOption<int, int>? opts]) {
    if (min is! String && min is! num || (max is! String && max is! num)) {
      throw StateError('min & max should be String or num');
    }
    return ZCountCommand._(['zcount', key, min, max], opts);
  }
}
