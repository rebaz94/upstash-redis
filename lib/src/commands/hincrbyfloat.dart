import 'package:upstash_redis/src/commands/command.dart';

class HIncrByFloatCommand extends Command<dynamic, num> {
  HIncrByFloatCommand._(super.command, super.opts);

  factory HIncrByFloatCommand(
    String key,
    String field,
    num increment, [
    CommandOption<num, num>? opts,
  ]) {
    return HIncrByFloatCommand._(['hincrbyfloat', key, field, increment], opts);
  }

  @override
  Future<num> exec(Requester client) async {
    final response = await client.request<dynamic>(body: command);
    final result = checkUpstashResponse<dynamic>(response);

    if (result is String) {
      return num.parse(result);
    } else if (result is num) {
      return result;
    }
    return deserialize(result);
  }
}
