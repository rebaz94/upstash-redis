import 'package:upstash_redis/src/commands/command.dart';

class TimeCommand extends Command<List<String>, List<int>> {
  TimeCommand._(super.command, super.opts, super.deserialize);

  factory TimeCommand([CommandOption<List<String>, List<int>>? opts]) {
    return TimeCommand._(
      ['time'],
      opts,
      (result) => result.map((e) => int.parse(e)).toList(),
    );
  }
}
