import 'package:upstash_redis/src/commands/command.dart';

class GetCommand<TData> extends Command<dynamic, TData?> {
  GetCommand._(super.command, super.opts);

  factory GetCommand(
    List<dynamic> command, [
    CommandOption<dynamic, TData?>? opts,
  ]) {
    return GetCommand._(['get', ...command], opts);
  }
}
