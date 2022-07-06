import 'package:upstash_redis/src/commands/command.dart';

class HKeysCommand extends Command<List<String>, List<String>> {
  HKeysCommand._(super.command, super.opts);

  factory HKeysCommand(String key, [CommandOption<List<String>, List<String>>? opts]) {
    return HKeysCommand._(['hkeys', key], opts);
  }

  @override
  Future<List<String>> exec(Requester client) async {
    final response = await client.request<dynamic>(body: command);
    final result = checkUpstashResponse<dynamic>(response);

    if (result is List) {
      return List<String>.from(result);
    }

    return deserialize(result);
  }
}
