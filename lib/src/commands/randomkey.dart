import 'package:upstash_redis/src/commands/command.dart';

class RandomKeyCommand extends Command<String?, String?> {
  RandomKeyCommand._(super.command, super.opts);

  factory RandomKeyCommand([CommandOption<String?, String?>? opts]) {
    return RandomKeyCommand._(['randomkey'], opts);
  }
}
