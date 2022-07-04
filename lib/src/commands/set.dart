import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class SetCommand<TData, TResult extends String> extends Command<TResult?, String?> {
  SetCommand._(super.command, super.opts);

  factory SetCommand(
    String key,
    TData value, {
    int? ex,
    int? px,
    bool? nx,
    bool? xx,
    CommandOption<TResult, String>? cmdOpts,
  }) {
    final command = ["set", key, value];

    if (ex != null && px != null) {
      throw StateError('should only provide "ex" or "px"');
    }

    if (nx != null && xx != null) {
      throw StateError('should only provide "nx" or "xx"');
    }

    if (ex is int) {
      command.addAll(['ex', ex]);
    } else if (px is int) {
      command.addAll(['px', px]);
    }

    if (nx == true) {
      command.add('nx');
    } else if (xx == true) {
      command.add('xx');
    }

    return SetCommand._(command, cmdOpts);
  }
}
