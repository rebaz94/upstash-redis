import 'package:collection/collection.dart';
import 'package:upstash_redis/src/commands/command.dart';

class MSetCommand<TData> extends Command<String, String> {
  MSetCommand._(super.command, super.opts);

  factory MSetCommand(Map<String, TData> kv, [CommandOption<String, String>? opts]) {
    return MSetCommand._([
      'mset',
      ...kv.entries.map((e) => [e.key, e.value]).flattened
    ], opts);
  }
}
