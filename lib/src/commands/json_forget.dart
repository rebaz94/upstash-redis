import 'package:upstash_redis/src/commands/command.dart';

class JsonForgetCommand extends Command<int, int> {
  JsonForgetCommand._(super.command, super.opts);

  factory JsonForgetCommand(
    String key, [
    String? path,
    CommandOption<int, int>? opts,
  ]) {
    return JsonForgetCommand._(
      [
        'JSON.FORGET',
        key,
        if (path != null) path,
      ],
      opts,
    );
  }
}
