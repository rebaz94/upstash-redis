import 'package:upstash_redis/src/commands/command.dart';

class LPosCommand<TData> extends Command<TData, TData> {
  LPosCommand._(super.command, super.opts);

  factory LPosCommand(
    String key,
    dynamic element, {
    int? rank,
    int? count,
    int? maxLen,
    CommandOption<TData, TData>? opts,
  }) {
    return LPosCommand._(
      [
        'lpos',
        key,
        element,
        if (rank != null) ...['rank', rank],
        if (count != null) ...['count', count],
        if (maxLen != null) ...['maxLen', maxLen],
      ],
      opts,
    );
  }
}
