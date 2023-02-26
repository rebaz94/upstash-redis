import 'package:upstash_redis/src/commands/command.dart';

class JsonObjLenCommand extends Command<List<int?>, List<int?>> {
  JsonObjLenCommand._(super.command, super.opts);

  factory JsonObjLenCommand(
    String key, [
    String? path,
    CommandOption<List<int?>, List<int?>>? opts,
  ]) {
    return JsonObjLenCommand._(
        ['JSON.OBJLEN', key, if (path != null) path], opts);
  }
}
