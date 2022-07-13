import 'package:upstash_redis/src/commands/command.dart';

class ScriptLoadCommand<TData> extends Command<String, String> {
  ScriptLoadCommand._(super.command, super.opts);

  factory ScriptLoadCommand(
    String script, [
    CommandOption<String, String>? opts,
  ]) {
    return ScriptLoadCommand._(['script', 'load', script], opts);
  }
}
