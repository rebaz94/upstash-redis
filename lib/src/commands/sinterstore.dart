import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class SInterStoreCommand extends Command<int, int> {
  SInterStoreCommand._(super.command, super.opts);

  factory SInterStoreCommand(
    String destination,
    List<String> keys, [
    CommandOption<int, int>? opts,
  ]) {
    return SInterStoreCommand._(['sinterstore', destination, ...keys], opts);
  }
}
