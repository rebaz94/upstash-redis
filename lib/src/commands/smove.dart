import 'package:upstash_redis/src/commands/command.dart';

class SMoveCommand<TData> extends Command<dynamic, int> {
  SMoveCommand._(super.command, super.opts);

  factory SMoveCommand(
    String source,
    String destination,
    TData member, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return SMoveCommand._(['smove', source, destination, member], opts);
  }
}
