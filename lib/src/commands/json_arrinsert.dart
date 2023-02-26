import 'package:upstash_redis/src/commands/command.dart';

class JsonArrInsertCommand<TData> extends Command<List<dynamic>, List<int?>> {
  JsonArrInsertCommand._(super.command, super.opts, super.deserialize);

  factory JsonArrInsertCommand(
    String key,
    String path,
    int index,
    List<TData> values, [
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return JsonArrInsertCommand._(
      [
        'JSON.ARRINSERT',
        key,
        path,
        index,
        ...values,
      ],
      opts,
      CommandOption.defaultListOfNullableStringToIntDeserializer,
    );
  }
}
