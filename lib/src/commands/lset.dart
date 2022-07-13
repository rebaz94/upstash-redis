import 'package:upstash_redis/src/commands/command.dart';

class LSetCommand<TData> extends Command<String, String> {
  LSetCommand._(super.command, super.opts);

  factory LSetCommand(
    String key,
    int index,
    TData value, [
    CommandOption<String, String>? opts,
  ]) {
    return LSetCommand._(['lset', key, index, value], opts);
  }
}
