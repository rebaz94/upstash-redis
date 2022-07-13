import 'package:upstash_redis/src/commands/command.dart';

class EvalshaCommand<TArgs, TData> extends Command<dynamic, TData> {
  EvalshaCommand._(super.command, super.opts);

  factory EvalshaCommand(
    String sha,
    List<String> keys, [
    List<TArgs> args = const [],
    CommandOption<dynamic, TData>? opts,
  ]) {
    return EvalshaCommand._(
      ['evalsha', sha, keys.length, ...keys, ...args],
      opts,
    );
  }
}
