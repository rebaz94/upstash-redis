import 'package:upstash_redis/src/commands/command.dart';

class SRandMemberCommand<TData> extends Command<dynamic, TData?> {
  SRandMemberCommand._(super.command, super.opts);

  factory SRandMemberCommand(
    String key, [
    int? count,
    CommandOption<dynamic, TData?>? opts,
  ]) {
    return SRandMemberCommand._([
      'srandmember',
      key,
      if (count != null) count,
    ], opts);
  }
}
