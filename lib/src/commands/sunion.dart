import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class SUnionCommand<TData> extends Command<List<String>, List<TData>> {
  SUnionCommand._(super.command, super.opts);

  factory SUnionCommand(
    List<String> keys, [
    CommandOption<List<String>, List<TData>>? opts,
  ]) {
    return SUnionCommand._(['sunion', ...keys], opts);
  }
}
