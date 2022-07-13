import 'package:upstash_redis/src/commands/command.dart';

class ZRankCommand<TData> extends Command<int?, int?> {
  ZRankCommand._(super.command, super.opts);

  factory ZRankCommand(String key, TData member, [CommandOption<int?, int?>? opts]) {
    return ZRankCommand._(['zrank', key, member], opts);
  }
}
