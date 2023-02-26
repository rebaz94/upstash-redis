import 'package:upstash_redis/src/commands/command.dart';

class JsonArrPopCommand<TData> extends Command<List<dynamic>, List<TData?>> {
  JsonArrPopCommand._(super.command, super.opts);

  factory JsonArrPopCommand(
    String key, [
    String? path,
    int? index,
    CommandOption<List<dynamic>, List<TData?>>? opts,
  ]) {
    final customDeserialize = opts?.deserialize != null;

    if (!customDeserialize) {
      final type = TData.toString().replaceAll('?', '');
      opts = CommandOption.fromListStringToNumericBy(type);
    }

    return JsonArrPopCommand._(
      [
        'JSON.ARRPOP',
        key,
        if (path != null) path,
        if (index != null) index,
      ],
      opts,
    );
  }
}
