import 'package:upstash_redis/src/commands/command.dart';

class GetCommand<TData> extends Command<dynamic, TData?> {
  GetCommand._(super.command, super.opts);

  factory GetCommand(
    List<String> keys, [
    CommandOption<dynamic, TData?>? opts,
  ]) {
    return GetCommand._(['get', ...keys], opts);
  }
}
