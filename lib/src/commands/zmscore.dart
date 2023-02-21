import 'package:upstash_redis/src/commands/command.dart';

class ZMScoreCommand<TData> extends Command<List<String?>, List<num?>> {
  ZMScoreCommand._(super.command, super.opts, super.deserialize);

  factory ZMScoreCommand(
    String key,
    List<TData> members, [
    CommandOption<List<String?>, List<num?>>? opts,
  ]) {
    return ZMScoreCommand._(
        ['zmscore', key, ...members], opts, _defaultDeserialize);
  }

  static List<num?> _defaultDeserialize(List<String?> result) {
    return result
        .map((value) => value == null ? null : num.tryParse(value))
        .toList();
  }
}
