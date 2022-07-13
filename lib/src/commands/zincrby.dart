import 'package:upstash_redis/src/commands/command.dart';

class ZIncrByCommand<TData> extends Command<String, num> {
  ZIncrByCommand._(super.command, super.opts);

  factory ZIncrByCommand(
    String key,
    num increment,
    TData member, [
    CommandOption<String, num>? opts,
  ]) {
    return ZIncrByCommand._(['zincrby', key, increment, member], opts);
  }
}
