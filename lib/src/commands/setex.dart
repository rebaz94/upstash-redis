import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class SetExCommand<TData> extends Command<String, String> {
  SetExCommand._(super.command, super.opts);

  factory SetExCommand(
    String key,
    int ttl,
    TData value, [
    CommandOption<String, String>? opts,
  ]) {
    return SetExCommand._(['setex', key, ttl, value], opts);
  }
}
