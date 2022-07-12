import 'package:upstash_redis/src/commands/command.dart';

class SRemCommand<TData> extends Command<int, int> {
  SRemCommand._(super.command, super.opts);

  factory SRemCommand(
    String key,
    List<TData> members, [
    CommandOption<int, int>? opts,
  ]) {
    return SRemCommand._(['srem', key, ...members], opts);
  }
}
