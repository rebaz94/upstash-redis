import 'package:upstash_redis/src/commands/command.dart';

class ZPopMaxCommand<TData> extends Command<List<dynamic>, List<TData>> {
  ZPopMaxCommand._(super.command, super.opts);

  factory ZPopMaxCommand(
    String key, {
    int? count,
    CommandOption<List<dynamic>, List<TData>>? opts,
  }) {
    return ZPopMaxCommand._([
      'zpopmax',
      key,
      if (count != null) count,
    ], opts);
  }
}
