import 'package:upstash_redis/src/commands/command.dart';

class SMIsMemberCommand<TMembers> extends Command<List<dynamic>, List<int>> {
  SMIsMemberCommand._(super.command, super.opts);

  factory SMIsMemberCommand(
    String key,
    List<TMembers> members, [
    CommandOption<List<dynamic>, List<int>>? opts,
  ]) {
    return SMIsMemberCommand._(['smismember', key, ...members], opts);
  }
}
