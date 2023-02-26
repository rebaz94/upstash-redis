import 'dart:convert';

import 'package:upstash_redis/src/commands/command.dart';

class JsonNumMultByCommand extends Command<String?, List<num?>> {
  JsonNumMultByCommand._(super.command, super.opts, super.deserialize);

  factory JsonNumMultByCommand(
    String key,
    String path,
    num value, [
    CommandOption<String?, List<num?>>? opts,
  ]) {
    return JsonNumMultByCommand._(
      ['JSON.NUMMULTBY', key, path, value],
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
