import 'package:upstash_redis/src/commands/command.dart';

class KeysCommand extends Command<List<String>, List<String>> {
  KeysCommand._(super.command, super.opts);

  factory KeysCommand(String pattern, [CommandOption<List<String>, List<String>>? opts]) {
    return KeysCommand._(['keys', pattern], opts);
  }
}
