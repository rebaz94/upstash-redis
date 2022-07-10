import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class PExpireCommand extends Command< /*String|int*/ dynamic, int> {
  PExpireCommand._(super.command, super.opts);

  factory PExpireCommand(
    String key,
    int milliseconds, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return PExpireCommand._(['pexpire', key, milliseconds], opts);
  }
}
