import 'package:upstash_redis/src/commands/command.dart';

class JsonDelCommand extends Command<int, int> {
  JsonDelCommand._(super.command, super.opts);

  factory JsonDelCommand(
    String key, [
    String? path,
    CommandOption<int, int>? opts,
  ]) {
    return JsonDelCommand._(
      [
        'JSON.DEL',
        key,
        if (path != null) path,
      ],
      opts,
    );
  }
}
