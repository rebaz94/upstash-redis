import 'package:upstash_redis/src/commands/command.dart';

class IncrByFloatCommand extends Command<dynamic, num> {
  IncrByFloatCommand._(super.command, super.opts);

  factory IncrByFloatCommand(String key, num value, [CommandOption<num, num>? opts]) {
    return IncrByFloatCommand._(['incrbyfloat', key, value], opts);
  }

  @override
  Future<num> exec(Requester client) async {
    final response = await client.request<dynamic>(body: command);
    final result = checkUpstashResponse<dynamic>(response);
    return deserialize(result is num ? result : num.parse('$result'));
  }
}
