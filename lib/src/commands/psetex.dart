import 'package:upstash_redis/src/commands/command.dart';

class PSetEXCommand<TData> extends Command<String, String> {
  PSetEXCommand._(super.command, super.opts);

  factory PSetEXCommand(
    String key,
    int ttl,
    TData value, [
    CommandOption<String, String>? opts,
  ]) {
    return PSetEXCommand._(['psetex', key, ttl, value], opts);
  }
}
