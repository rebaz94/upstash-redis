import 'package:upstash_redis/src/commands/command.dart';

class SMembersCommand<TData> extends Command<List<dynamic>, List<TData>> {
  SMembersCommand._(super.command, super.opts);

  factory SMembersCommand(
    String key, [
    CommandOption<List<dynamic>, List<TData>>? opts,
  ]) {
    return SMembersCommand._(['smembers', key], opts);
  }
}
