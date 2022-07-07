import 'package:upstash_redis/src/commands/command.dart';

class KeysCommand extends Command<List<String>, List<String>> {
  KeysCommand._(super.command, super.opts);

  factory KeysCommand(String pattern, [CommandOption<List<String>, List<String>>? opts]) {
    return KeysCommand._(['keys', pattern], opts);
  }

  @override
  Future<List<String>> exec(Requester client) async {
    final response = await client.request<List>(body: command);
    final result = checkUpstashResponse<List>(response);
    return deserialize(List<String>.from((result ?? [])));
  }
}
