import 'package:upstash_redis/src/commands/command.dart';

class ZDiffStoreCommand extends Command<num, num> {
  ZDiffStoreCommand._(super.command, super.opts);

  factory ZDiffStoreCommand(
    String destination,
    num numKeys,
    List<String> keys, [
    CommandOption<num, num>? opts,
  ]) {
    return ZDiffStoreCommand._(
        ['zdiffstore', destination, numKeys, ...keys], opts);
  }
}
