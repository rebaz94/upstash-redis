import 'package:upstash_redis/src/commands/command.dart';

class ExpireCommand extends Command<int, int> {
  ExpireCommand._(super.command, super.opts);

  factory ExpireCommand(
    String key,
    int seconds, [
    CommandOption<int, int>? opts,
  ]) {
    return ExpireCommand._(['expire', key, seconds], opts);
  }
}
