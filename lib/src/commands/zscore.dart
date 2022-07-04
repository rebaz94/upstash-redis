import 'package:upstash_redis/src/commands/command.dart';

class ZScoreCommand<TData> extends Command<String?, num?> {
  ZScoreCommand._(super.command, super.opts);

  factory ZScoreCommand(
    String key,
    TData member, [
    CommandOption<String?, num?>? opts,
  ]) {
    return ZScoreCommand._(['zscore', key, member], opts);
  }
}
