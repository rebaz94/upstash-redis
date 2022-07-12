import 'package:upstash_redis/src/commands/command.dart';

class SUnionStoreCommand extends Command<int, int> {
  SUnionStoreCommand._(super.command, super.opts);

  factory SUnionStoreCommand(
    String destination,
    List<String> keys, [
    CommandOption<int, int>? opts,
  ]) {
    return SUnionStoreCommand._(['sunionstore', destination, ...keys], opts);
  }
}
