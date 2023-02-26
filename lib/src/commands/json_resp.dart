import 'package:upstash_redis/src/commands/command.dart';

class JsonRespCommand<TData> extends Command<TData, TData> {
  JsonRespCommand._(super.command, super.opts);

  factory JsonRespCommand(
    String key, [
    String? path,
    CommandOption<TData, TData>? opts,
  ]) {
    return JsonRespCommand._(['JSON.RESP', key, if (path != null) path], opts);
  }
}
