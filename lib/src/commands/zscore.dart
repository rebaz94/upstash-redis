import 'package:upstash_redis/src/commands/command.dart';

class ZScoreCommand<TData> extends Command<String?, num?> {
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

    if (result is String) {
      return num?.tryParse(result);
    } else if (result is num) {
      return result;
    }
    return deserialize(result);
  }
}
