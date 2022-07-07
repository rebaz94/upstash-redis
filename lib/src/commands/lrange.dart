import 'package:upstash_redis/src/commands/command.dart';

class LRangeCommand<TData> extends Command<List<Object?>, List<TData>> {
  LRangeCommand._(super.command, super.opts);

  factory LRangeCommand(
    String key,
    int start,
    int end, [
    CommandOption<List<Object?>, List<TData>>? opts,
  ]) {
    return LRangeCommand._(['lrange', key, start, end], opts);
  }

  @override
  Future<List<TData>> exec(Requester client) async {
    final response = await client.request<List>(body: command);
    final result = checkUpstashResponse<List>(response);

    return deserialize(List<String>.from(result ?? []));
  }
}
