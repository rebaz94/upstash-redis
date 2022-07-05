import 'package:upstash_redis/src/commands/command.dart';

class FlushDbCommand extends Command<String, String> {
  FlushDbCommand._(super.command, super.opts);

  factory FlushDbCommand({bool? async, CommandOption<String, String>? opts}) {
    return FlushDbCommand._(['flushdb', if (async == true) 'async'], opts);
  }
}
