import 'package:upstash_redis/src/commands/command.dart';

class IncrByCommand extends Command<int, int> {
  IncrByCommand._(super.command, super.opts);

  factory IncrByCommand(
    String key,
    int value, [
    CommandOption<int, int>? opts,
  ]) {
    return IncrByCommand._(['incrby', key, value], opts);
  }
}
