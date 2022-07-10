import 'package:upstash_redis/src/commands/command.dart';

class PublishCommand<TData> extends Command<int, int> {
  PublishCommand._(super.command, super.opts);

  factory PublishCommand(String channel, TData message, [CommandOption<int, int>? opts]) {
    return PublishCommand._(['publish', channel, message], opts);
  }
}
