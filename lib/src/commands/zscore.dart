import 'package:upstash_redis/src/commands/command.dart';

class ZScoreCommand<TData> extends Command<dynamic, num?> {
  ZScoreCommand._(super.command, super.opts);

  factory ZScoreCommand(
    String key,
    TData member, [
    CommandOption<String?, num?>? opts,
  ]) {
    return ZScoreCommand._(['zscore', key, member], opts);
  }

  @override
  Future<num?> exec(Requester client) async {
    final response = await client.request<dynamic>(body: command);
    final result = checkUpstashResponse<dynamic>(response);

    dynamic value = result;
    if (result is String) {
      value = num.tryParse(result);
    } else if (result is num) {
      value = result;
    }
    return deserialize(value);
  }
}
