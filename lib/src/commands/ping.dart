import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class PingCommand extends Command<String, String> {
  PingCommand._(super.command, super.opts);

  factory PingCommand([
    String? message,
    CommandOption<String, String>? opts,
  ]) {
    return PingCommand._(['ping', if (message != null) message], opts);
  }
}
