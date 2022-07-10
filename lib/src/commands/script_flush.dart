import 'package:upstash_redis/src/commands/command.dart';

class ScriptFlushCommand extends Command<String, String> {
  ScriptFlushCommand._(super.command, super.opts);

  factory ScriptFlushCommand({
    bool? sync,
    bool? async,
    CommandOption<String, String>? opts,
  }) {
    if (sync == true && async == true) {
      throw StateError('it should only be sync or async');
    }
    return ScriptFlushCommand._([
      'script',
      'flush',
      if (sync == true) 'sync' else if (async == true) 'async',
    ], opts);
  }
}
