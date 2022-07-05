import 'package:upstash_redis/src/commands/command.dart';

class FlushAllCommand extends Command<String, String> {
  FlushAllCommand._(super.command, super.opts);

  factory FlushAllCommand({bool? async, CommandOption<String, String>? opts}) {
    return FlushAllCommand._(['flushall', if (async == true) 'async'], opts);
  }
}
