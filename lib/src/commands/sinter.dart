import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class SInterCommand<TData> extends Command<List<dynamic>, List<TData>> {
  SInterCommand._(super.command, super.opts);

  factory SInterCommand(List<String> keys, [CommandOption<List<dynamic>, List<TData>>? opts]) {
    return SInterCommand._(['sinter', keys], opts);
  }
}
