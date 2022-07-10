import 'package:upstash_redis/src/commands/command.dart';

class ScriptExistsCommand extends Command<List<int>, List<int>> {
  ScriptExistsCommand._(super.command, super.opts);

  factory ScriptExistsCommand(
    List<String> hashes, [
    CommandOption<List<int>, List<int>>? opts,
  ]) {
    return ScriptExistsCommand._(
      ['script', 'exists', ...hashes],
      opts,
    );
  }
}
