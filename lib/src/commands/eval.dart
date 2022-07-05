import 'package:upstash_redis/src/commands/command.dart';

class EvalCommand<TArgs, TData> extends Command<dynamic, TData> {
  EvalCommand._(super.command, super.opts);

  factory EvalCommand(
    String script,
    List<String> keys, [
    List<TArgs> args = const [],
    CommandOption<dynamic, TData>? opts,
  ]) {
    return EvalCommand._(['eval', script, keys.length, ...keys, ...args], opts);
  }
}
