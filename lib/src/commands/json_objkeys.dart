import 'package:upstash_redis/src/commands/command.dart';

class JsonObjKeysCommand extends Command<List<dynamic> /*List<List<String>?>*/,
    List<List<String>?>> {
  JsonObjKeysCommand._(super.command, super.opts, super.deserialize);

  factory JsonObjKeysCommand(
    String key, [
    String? path,
    CommandOption<List<List<String>?>, List<List<String>?>>? opts,
  ]) {
    return JsonObjKeysCommand._(
      ['JSON.OBJKEYS', key, if (path != null) path],
      opts,
      _defaultSerializer,
    );
  }

  static List<List<String>?> _defaultSerializer(List<dynamic> results) {
    return results.map((e) => e is List ? List<String>.from(e) : null).toList();
  }
}
