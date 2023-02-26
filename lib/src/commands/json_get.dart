import 'dart:convert';

import 'package:upstash_redis/src/commands/command.dart';

class JsonGetCommand<TData> extends Command<dynamic, TData?> {
  JsonGetCommand._(super.command, super.opts);

  factory JsonGetCommand(
    String key,
    List<String> path, {
    String? indent,
    String? newline,
    String? space,
    CommandOption<dynamic, TData?>? opts,
  }) {
    final hasOptions = indent != null || newline != null || space != null;
    return JsonGetCommand._(
      [
        'JSON.GET',
        if (!hasOptions) ...[
          key,
          ...path
        ] else ...[
          key,
          if (indent != null) ...['INDENT', indent],
          if (newline != null) ...['NEWLINE', newline],
          if (space != null) ...['SPACE', space],
          ...path,
        ],
      ],
      opts,
    );
  }

  @override
  Future<TData?> exec(Requester client) async {
    final response = await client.request<String?>(body: command);
    final result = checkUpstashResponse<String?>(response);

    if (result == null) return null;

    final decoded = json.decode(result);
    return deserialize(decoded);
  }
}
