import 'package:upstash_redis/src/commands/command.dart';

class JsonArrIndexCommand<TValue> extends Command<List<dynamic>, List<int?>> {
  JsonArrIndexCommand._(super.command, super.opts, super.deserialize);

  factory JsonArrIndexCommand(
    String key,
    String path,
    TValue value, {
    num? start,
    num? stop,
    CommandOption<List<dynamic>, List<int?>>? opts,
  }) {
    return JsonArrIndexCommand._(
      [
        'JSON.ARRINDEX',
        key,
        path,
        value,
        if (start != null) start,
        if (stop != null) stop,
      ],
      opts,
      CommandOption.defaultListOfNullableStringToIntDeserializer,
    );
  }
}
