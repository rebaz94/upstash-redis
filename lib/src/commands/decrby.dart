import 'package:upstash_redis/src/commands/command.dart';

class DecrByCommand extends Command<int, int> {
  DecrByCommand._(super.command, super.opts);

  factory DecrByCommand(
    String key,
    int decrement, [
    CommandOption<int, int>? opts,
  ]) {
    return DecrByCommand._(['decrby', key, decrement], opts);
  }
}
