import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class PersistCommand extends Command< /*String|int*/ dynamic, int> {
  PersistCommand._(super.command, super.opts);

  factory PersistCommand(
    String key, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return PersistCommand._(['persist', key], opts);
  }
}
