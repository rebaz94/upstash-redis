import 'package:upstash_redis/src/commands/command.dart';

class RenameNXCommand extends Command<dynamic, int> {
  RenameNXCommand._(super.command, super.opts);

  factory RenameNXCommand(
    String source,
    String destination, [
    CommandOption<dynamic, int>? opts,
  ]) {
    return RenameNXCommand._(['renamenx', source, destination], opts);
  }
}
