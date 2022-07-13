import 'package:upstash_redis/src/commands/command.dart';

class ZRevRankCommand<TData> extends Command<int?, int?> {
  ZRevRankCommand._(super.command, super.opts);

  factory ZRevRankCommand(
    String key,
    TData member, [
    CommandOption<int?, int?>? opts,
  ]) {
    return ZRevRankCommand._(['zrevrank', key, member], opts);
  }
}
