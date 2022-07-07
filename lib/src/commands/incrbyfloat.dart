import 'package:upstash_redis/src/commands/command.dart';

class IncrByFloatCommand extends Command<num, num> {
  IncrByFloatCommand._(super.command, super.opts);

  factory IncrByFloatCommand(String key, num value, [CommandOption<num, num>? opts]) {
    return IncrByFloatCommand._(['incrbyfloat', key, value], opts);
  }

  @override
  Future<num> exec(Requester client) async {
    final response = await client.request<String>(body: command);
    final result = checkUpstashResponse<String>(response);
    return deserialize(num.parse(result ?? ''));
  }
}
