import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class SetNxCommand<TData extends String> extends Command<int, int> {
  SetNxCommand._(super.command, super.opts);

  factory SetNxCommand(
    String key,
    TData value, [
    CommandOption<int, int>? opts,
  ]) {
    return SetNxCommand._(['setnx', key, value], opts);
  }
}
