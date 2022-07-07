import 'package:upstash_redis/src/commands/command.dart';

class HValsCommand<TData> extends Command<List<TData>, List<TData>> {
  HValsCommand._(super.command, super.opts);

  factory HValsCommand(String key, [CommandOption<List<TData>, List<TData>>? opts]) {
    return HValsCommand._(['hvals', key], opts);
  }

  @override
  Future<List<TData>> exec(Requester client) async {
    final response = await client.request<dynamic>(body: command);
    var result = checkUpstashResponse<dynamic>(response);

    if (result is List) {
      result = List<String>.from(result);
    }

    return deserialize(result);
  }
}
