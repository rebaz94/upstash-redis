import 'package:upstash_redis/src/commands/command.dart';

class JsonClearCommand extends Command<int, int> {
  JsonClearCommand._(super.command, super.opts);

  factory JsonClearCommand(
    String key, [
    String? path,
    CommandOption<int, int>? opts,
  ]) {
    return JsonClearCommand._(
      [
        'JSON.CLEAR',
        key,
        if (path != null) path,
      ],
      opts,
    );
  }
}
