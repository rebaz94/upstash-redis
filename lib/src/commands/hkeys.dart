import 'package:upstash_redis/src/commands/command.dart';

class HKeysCommand extends Command<List<String>, List<String>> {
  HKeysCommand._(super.command, super.opts);

  factory HKeysCommand(
    String key, [
    CommandOption<List<String>, List<String>>? opts,
  ]) {
    return HKeysCommand._(['hkeys', key], opts);
  }
}
