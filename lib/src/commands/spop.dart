import 'package:upstash_redis/src/commands/command.dart';

class SPopCommand<TData> extends Command<dynamic, TData?> {
  SPopCommand._(super.command, super.opts);

  factory SPopCommand(
    String key, [
    int? count,
    CommandOption<dynamic, TData?>? opts,
  ]) {
    return SPopCommand._([
      'spop',
      key,
      if (count != null) count,
    ], opts);
  }
}
