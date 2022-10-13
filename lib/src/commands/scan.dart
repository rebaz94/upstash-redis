import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/mod.dart';

class ScanCommand extends Command<List<dynamic>, List<dynamic>> {
  ScanCommand._(super.command, super.opts);

  factory ScanCommand(
    int cursor, {
    String? match,
    int? count,
    String? type,
    CommandOption<List<dynamic>, List<dynamic>>? opts,
  }) {
    return ScanCommand._(
      [
        'scan',
        cursor,
        if (match != null) ...['match', match],
        if (count != null) ...['count', count],
        if (type != null && type.isNotEmpty) ...['type', type],
      ],
      opts,
    );
  }

  @override
  Future<List<dynamic>> exec(Requester client) async {
    final response = await client.request<dynamic>(body: command);
    var result = checkUpstashResponse<dynamic>(response);

    dynamic value = result;
    if (result is List && result.length == 2) {
      final cursor = result.first is int
          ? result.first //
          : int.parse('${result.first}');
      final values = List<String>.from(result.last);

      value = [cursor, values];
    }

    return deserialize(value);
  }
}
