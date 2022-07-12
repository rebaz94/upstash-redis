import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class SDiffStoreCommand extends Command<int, int> {
  SDiffStoreCommand._(super.command, super.opts);

  factory SDiffStoreCommand(
    List<String> keys, [
    CommandOption<int, int>? opts,
  ]) {
    return SDiffStoreCommand._(['sdiffstore', ...keys], opts);
  }
}
