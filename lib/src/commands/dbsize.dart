import 'package:upstash_redis/src/commands/command.dart';

class DbSizeCommand extends Command<int, int> {
  DbSizeCommand._(super.command, super.opts);

  factory DbSizeCommand([CommandOption<int, int>? opts]) {
    return DbSizeCommand._(['dbsize'], opts);
  }
}
