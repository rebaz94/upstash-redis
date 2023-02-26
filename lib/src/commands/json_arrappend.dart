import 'package:upstash_redis/src/commands/command.dart';

class JsonArrAppendCommand<TData> extends Command<List<dynamic>, List<int?>> {
  JsonArrAppendCommand._(super.command, super.opts, super.deserialize);

  factory JsonArrAppendCommand(
    String key,
    String path,
    TData values, [
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return JsonArrAppendCommand._(
      ['JSON.ARRAPPEND', key, path, values],
      opts,
      CommandOption.defaultListOfNullableStringToIntDeserializer,
    );
  }
}
