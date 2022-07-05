import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class BitCountCommand extends Command<int, int> {
  BitCountCommand._(super.command, super.opts);

  factory BitCountCommand(
    String key, {
    int? start,
    int? end,
    CommandOption<int, int>? opts,
  }) {
    assert(
      start != null && end != null || (start == null && end == null),
      'you should define both [start] and [end] parameter or define nothing',
    );
    final command = <dynamic>['bitcount', key];
    if (start != null) {
      command.add(start);
    }

    if (end != null) {
      command.add(end);
    }
    return BitCountCommand._(command, opts);
  }
}
