import 'package:upstash_redis/src/commands/command.dart';

import '../../upstash_redis.dart' show $;

class JsonArrLenCommand extends Command<List<dynamic>, List<int?>> {
  JsonArrLenCommand._(super.command, super.opts, super.deserialize);

  factory JsonArrLenCommand(
    String key, [
    String? path,
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return JsonArrLenCommand._(
      [
        'JSON.ARRLEN',
        key,
        path ?? $,
      ],
      opts,
      CommandOption.defaultListOfNullableStringToIntDeserializer,
    );
  }
}
