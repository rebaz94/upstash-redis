import 'package:upstash_redis/src/commands/command.dart';

class JsonTypeCommand extends Command<List<String>, List<String>> {
  JsonTypeCommand._(super.command, super.opts);

  factory JsonTypeCommand(
    String key, [
    String? path,
    CommandOption<List<String>, List<String>>? opts,
  ]) {
    return JsonTypeCommand._(['JSON.TYPE', key, if (path != null) path], opts);
  }
}
