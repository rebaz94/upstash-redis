import 'package:upstash_redis/src/commands/command.dart';

class GetDelCommand<TData> extends Command<Object?, TData?> {
  GetDelCommand._(super.command, super.opts);

  factory GetDelCommand(
    String key, [
    CommandOption<Object?, TData?>? opts,
  ]) {
    return GetDelCommand._(['getdel', key], opts);
  }
}
