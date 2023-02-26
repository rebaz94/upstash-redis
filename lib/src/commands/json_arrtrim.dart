import 'package:upstash_redis/src/commands/command.dart';

import '../../upstash_redis.dart' show $;

class JsonArrTrimCommand extends Command<List<dynamic>, List<int?>> {
  JsonArrTrimCommand._(super.command, super.opts, super.deserialize);

  factory JsonArrTrimCommand(
    String key, [
    String? path,
    int? start,
    int? stop,
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return JsonArrTrimCommand._(
      [
        'JSON.ARRTRIM',
        key,
        path ?? $,
        start ?? 0,
        stop ?? 0,
      ],
      opts,
      CommandOption.defaultListOfNullableStringToIntDeserializer,
    );
  }
}
