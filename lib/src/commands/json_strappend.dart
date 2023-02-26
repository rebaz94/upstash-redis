import 'package:upstash_redis/src/commands/command.dart';

class JsonStrAppendCommand
    extends Command<List<dynamic> /*List<String?>*/, List<int?>> {
  JsonStrAppendCommand._(super.command, super.opts, super.deserialize);

  factory JsonStrAppendCommand(
    String key,
    String path,
    String value, [
    CommandOption<List<dynamic>, List<int?>>? opts,
  ]) {
    return JsonStrAppendCommand._(
      ['JSON.STRAPPEND', key, path, value],
      opts,
      CommandOption.defaultListOfNullableStringToIntDeserializer,
    );
  }
}
