import 'package:upstash_redis/src/commands/command.dart';

class SIsMemberCommand<TData> extends Command<dynamic, int> {
  SIsMemberCommand._(super.command, super.opts);

  factory SIsMemberCommand(String key, TData member, [CommandOption<dynamic, int>? opts]) {
    return SIsMemberCommand._(['sismember', key, member], opts);
  }
}
