import 'package:upstash_redis/src/commands/command.dart';

class HExistsCommand extends Command<int, int> {
  HExistsCommand._(super.command, super.opts);

  factory HExistsCommand(
    String key,
    String field, [
    CommandOption<int, int>? opts,
  ]) {
    return HExistsCommand._(['hexists', key, field], opts);
  }
}
