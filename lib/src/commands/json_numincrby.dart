import 'dart:convert';

import 'package:upstash_redis/src/commands/command.dart';

class JsonNumIncrByCommand extends Command<String?, List<num?>> {
  JsonNumIncrByCommand._(super.command, super.opts, super.deserialize);

  factory JsonNumIncrByCommand(
    String key,
    String path,
    num value, [
    CommandOption<String?, List<num?>>? opts,
  ]) {
    return JsonNumIncrByCommand._(
      ['JSON.NUMINCRBY', key, path, value],
      opts,
      _defaultSerializer,
    );
  }

  static List<num?> _defaultSerializer(String? results) {
    if (results == null) return const [];

    final decoded = json.decode(results) as List;
    return decoded.map((e) {
      if (e is num) return e;
      if (e is String) return num.tryParse(e);
      return null;
    }).toList();
  }
}
