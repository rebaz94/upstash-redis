import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class HScanCommand extends Command<List<dynamic>, List<dynamic>> {
  HScanCommand._(super.command, super.opts);

  factory HScanCommand(
    String key,
    int cursor, {
    String? match,
    int? count,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    final command = ['hscan', key, cursor];
    if (match != null) {
      command.addAll(['match', match]);
    }

    if (count != null) {
      command.addAll(['count', count]);
    }
    return HScanCommand._(
      command,
      opts,
    );
  }

  @override
  Future<List<dynamic>> exec(Requester client) async {
    final response = await client.request<dynamic>(body: command);
    var result = checkUpstashResponse<dynamic>(response);

    if (result is List && result.length == 2) {
      final cursor = result.first is num ? result.first.toString() : result.first;
      final values = List<String>.from(result.last);

      return [cursor, values];
    }

    return deserialize(result);
  }
}
