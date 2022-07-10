import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class PExpireAtCommand extends Command< /*String|int*/ dynamic, int> {
  PExpireAtCommand._(super.command, super.opts);

  factory PExpireAtCommand(
    String key,
    int unix, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return PExpireAtCommand._(['pexpireat', key, unix], opts);
  }
}
