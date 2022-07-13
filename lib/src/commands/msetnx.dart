import 'package:collection/collection.dart';
import 'package:upstash_redis/src/commands/command.dart';

class MSetNXCommand<TData> extends Command<int, int> {
  MSetNXCommand._(super.command, super.opts);

  factory MSetNXCommand(
    Map<String, TData> kv, [
    CommandOption<int, int>? opts,
  ]) {
    return MSetNXCommand._([
      'msetnx',
      ...kv.entries.map((e) => [e.key, e.value]).flattened
    ], opts);
  }
}
