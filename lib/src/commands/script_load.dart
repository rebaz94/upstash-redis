import 'package:upstash_redis/src/commands/command.dart';

class ScripLoadCommand<TData> extends Command<String, String> {
  ScripLoadCommand._(super.command, super.opts);

  factory ScripLoadCommand(
    String script, [
    CommandOption<String, String>? opts,
  ]) {
    return ScripLoadCommand._(['script', 'load', script], opts);
  }
}
