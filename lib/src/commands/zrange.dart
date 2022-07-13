import 'package:upstash_redis/src/commands/command.dart';

class ZRangeCommand<TData> extends Command<List<dynamic>, List<TData>> {
  ZRangeCommand._(super.command, super.opts);

  static const _symbols = ['-', '+', '-inf', '+inf'];

  factory ZRangeCommand(
    String key,
    Object min,
    Object max, {
    bool? withScores,
    bool? rev,
    bool? byScore,
    bool? byLex,
    int? offset,
    int? count,
    CommandOption<List<String?>, List<TData>>? opts,
  }) {
    if (min is String) {
      if (!_symbols.contains(min) && !min.startsWith('(') && !min.startsWith('[')) {
        throw StateError('invalid min parameter, expected to be formatted like '
            '`(String` | `[String` | `(Number` | `-` | `+` | `-inf` | `+inf`');
      }
    } else if (min is! num) {
      throw StateError('invalid min parameter, it should be string or number');
    }

    if (max is String) {
      if (!_symbols.contains(max) && !max.startsWith('(') && !max.startsWith('[')) {
        throw StateError('invalid max parameter, expected to be formatted like '
            '`(String` | `[String` | `(Number` | `-` | `+` | `-inf` | `+inf`');
      }
    } else if (max is! num) {
      throw StateError('invalid max parameter, it should be string or number');
    }

    if (byScore == true && byLex == true) {
      throw StateError('either byScore or byLex is allowed but provided both!');
    }

    return ZRangeCommand._([
      'zrange',
      key,
      min,
      max,
      if (byScore == true) 'byscore' else if (byLex == true) 'bylex',
      if (rev == true) 'rev',
      if (offset != null && count != null) ...['limit', offset, count],
      if (withScores == true) 'withscores',
    ], opts);
  }
}
