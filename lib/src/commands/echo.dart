import 'package:upstash_redis/src/commands/command.dart';

class EchoCommand extends Command<String, String> {
  EchoCommand._(super.command, super.opts);

  factory EchoCommand(String message, [CommandOption<String, String>? opts]) {
    return EchoCommand._(['echo', message], opts);
  }
}
