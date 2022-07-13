import 'package:upstash_redis/src/commands/command.dart';

class RenameCommand extends Command<String, String> {
  RenameCommand._(super.command, super.opts);

  factory RenameCommand(
    String source,
    String destination, [
    CommandOption<String, String>? opts,
  ]) {
    return RenameCommand._(['rename', source, destination], opts);
  }
}
