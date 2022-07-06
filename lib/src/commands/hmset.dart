import 'package:collection/collection.dart';
import 'package:upstash_redis/src/commands/command.dart';

class HMSetCommand<TData> extends Command<String, String> {
  HMSetCommand._(super.command, super.opts);

  factory HMSetCommand(String key, Map<String, TData> kv, [CommandOption<String, String>? opts]) {
    return HMSetCommand._([
      'hmset',
      key,
      ...kv.entries.map((e) => [e.key, e.value]).flattened
    ], opts);
  }
}
