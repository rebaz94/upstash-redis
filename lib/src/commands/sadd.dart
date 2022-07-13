import 'package:upstash_redis/src/commands/command.dart';

class SAddCommand<TData> extends Command<int, int> {
  SAddCommand._(super.command, super.opts);

  factory SAddCommand(
    String key,
    List<TData> members, [
    CommandOption<int, int>? opts,
  ]) {
    return SAddCommand._(['sadd', key, ...members], opts);
  }
}
