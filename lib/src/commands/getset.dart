import 'package:upstash_redis/src/commands/command.dart';

class GetSetCommand<TData> extends Command<dynamic, TData?> {
  GetSetCommand._(super.command, super.opts);

  factory GetSetCommand(
    String key,
    TData value, [
    CommandOption<dynamic, TData?>? opts,
  ]) {
    return GetSetCommand._(['getset', key, value], opts);
  }
}
