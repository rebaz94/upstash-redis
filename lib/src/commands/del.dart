import 'package:upstash_redis/src/commands/command.dart';

class DelCommand extends Command<int, int> {
  DelCommand._(super.command, super.opts);

  factory DelCommand(
    List<String> command, [
    CommandOption<int, int>? opts,
  ]) {
    return DelCommand._(['del', ...command], opts);
  }
}
