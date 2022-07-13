import 'package:upstash_redis/src/commands/command.dart';

class ZPopMinCommand<TData> extends Command<List<dynamic>, List<TData>> {
  ZPopMinCommand._(super.command, super.opts);

  factory ZPopMinCommand(
    String key, {
    int? count,
    CommandOption<List<dynamic>, List<TData>>? opts,
  }) {
    return ZPopMinCommand._([
      'zpopmin',
      key,
      if (count != null) count,
    ], opts);
  }
}
