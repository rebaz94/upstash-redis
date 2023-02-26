import 'package:upstash_redis/src/commands/command.dart';

class JsonToggleCommand extends Command<List<int>, List<int>> {
  JsonToggleCommand._(super.command, super.opts);

  factory JsonToggleCommand(
    String key,
    String path, [
    CommandOption<List<int>, List<int>>? opts,
  ]) {
    return JsonToggleCommand._(['JSON.TOGGLE', key, path], opts);
  }
}
