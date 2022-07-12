import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class SDiffCommand<TData> extends Command<List<dynamic>, List<TData>> {
  SDiffCommand._(super.command, super.opts);

  factory SDiffCommand(
    List<String> keys, [
    CommandOption<List<dynamic>, List<TData>>? opts,
  ]) {
    return SDiffCommand._(['sdiff', ...keys], opts);
  }
}
