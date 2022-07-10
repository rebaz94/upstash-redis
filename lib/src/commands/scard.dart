import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class SCardCommand extends Command<int, int> {
  SCardCommand._(super.command, super.opts);

  factory SCardCommand(
    String key, [
    CommandOption<int, int>? opts,
  ]) {
    return SCardCommand._(['scard', key], opts);
  }
}
