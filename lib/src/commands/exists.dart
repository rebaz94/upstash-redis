import 'package:upstash_redis/src/commands/command.dart';

class ExistsCommand extends Command<int, int> {
  ExistsCommand._(super.command, super.opts);

  factory ExistsCommand(List<String> keys, [CommandOption<int, int>? opts]) {
    return ExistsCommand._(['exists', ...keys], opts);
  }
}
