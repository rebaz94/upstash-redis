import 'package:upstash_redis/src/commands/command.dart';

class HIncrByCommand extends Command<int, int> {
  HIncrByCommand._(super.command, super.opts);

  factory HIncrByCommand(
    String key,
    String field,
    int increment, [
    CommandOption<int, int>? opts,
  ]) {
    return HIncrByCommand._(['hincrby', key, field, increment], opts);
  }
}
