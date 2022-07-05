import 'package:collection/collection.dart';
import 'package:upstash_redis/src/commands/command.dart';

class HSetCommand<TData> extends Command<int, int> {
  HSetCommand._(super.command, super.opts);

  factory HSetCommand(String key, Map<String, TData> kv, [CommandOption<int, int>? opts]) {
    return HSetCommand._([
      'hset',
      key,
      ...kv.entries.map((e) => [e.key, e.value]).flattened
    ], opts);
  }
}
