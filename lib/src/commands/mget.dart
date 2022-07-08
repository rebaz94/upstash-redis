import 'package:upstash_redis/src/commands/command.dart';

class MGetCommand<TData> extends Command<List<String?>, List<TData?>> {
  MGetCommand._(super.command, super.opts);

  factory MGetCommand(
    List<String> keys, [
    CommandOption<List<String?>, List<TData?>>? opts,
  ]) {
    return MGetCommand._(['mget', ...keys], opts);
  }
}
