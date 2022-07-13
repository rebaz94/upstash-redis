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
    return HScanCommand._(
      [
        'hscan',
        key,
        cursor,
        if (match != null) ...['match', match],
        if (count != null) ...['count', count],
      ],
      opts,
    );
  }

  @override
  Future<List<dynamic>> exec(Requester client) async {
    final response = await client.request<dynamic>(body: command);
    final result = checkUpstashResponse<dynamic>(response);

    dynamic value = result;
    if (result is List && result.length == 2) {
      final cursor = result.first is int
          ? result.first.toString()
          : int.parse('${result.first}');
      final values = List<String>.from(result.last);

      value = [cursor, values];
    }

    return deserialize(value);
  }
}
