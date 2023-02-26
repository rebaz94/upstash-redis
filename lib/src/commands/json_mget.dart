import 'package:upstash_redis/src/commands/command.dart';

class JsonMGetCommand<TData> extends Command<TData, TData> {
  JsonMGetCommand._(super.command, super.opts);

  factory JsonMGetCommand(
    List<String> keys,
    String path, {
    CommandOption<TData, TData>? opts,
  }) {
    return JsonMGetCommand._(['JSON.MGET', ...keys, path], opts);
  }
}
