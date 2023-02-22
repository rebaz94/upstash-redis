import 'dart:convert';

import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/utils.dart';

TData? _deserialize<TData>(List<String> result) {
  if (result.isEmpty) return null;

  final obj = <String, dynamic>{};
  while (result.length >= 2) {
    final key = result.removeAt(0);
    final value = result.removeAt(0);

    try {
      obj[key] = parseResponse(json.decode(value) as Map);
    } catch (_) {
      obj[key] = value as TData;
    }
  }

  return obj as TData;
}

class HRandFieldCommand<TData>
    extends Command<dynamic /*String | List<String>*/, TData> {
  HRandFieldCommand._(
    super.command,
    super.opts,
    super.deserialize,
  );

  factory HRandFieldCommand(
    String key, {
    num? count,
    bool? withValues,
    CommandOption<dynamic, TData>? opts,
  }) {
    return HRandFieldCommand._(
      [
        'hrandfield',
        key,
        if (count != null) count,
        if (withValues == true) 'WITHVALUES',
      ],
      opts,
      withValues == true
          ? (result) => _deserialize(List<String>.from(result as List))
          : opts?.deserialize,
    );
  }
}
