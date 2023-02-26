import 'package:upstash_redis/src/commands/command.dart';

class JsonStrLenCommand extends Command<List<int?>, List<int?>> {
  JsonStrLenCommand._(super.command, super.opts);

  factory JsonStrLenCommand(
    String key, [
    String? path,
    CommandOption<List<int?>, List<int?>>? opts,
  ]) {
    return JsonStrLenCommand._(
        ['JSON.STRLEN', key, if (path != null) path], opts);
  }
}
