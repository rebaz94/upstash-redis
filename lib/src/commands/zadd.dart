import 'package:upstash_redis/src/commands/command.dart';
import 'package:collection/collection.dart';

class ScoreMember<TData> {
  const ScoreMember({
    required this.score,
    required this.member,
  });

  final num score;
  final TData member;
}

class ZAddCommand<TData> extends Command<dynamic, num?> {
  ZAddCommand._(super.command, super.opts);

  factory ZAddCommand.single(
    String key, {
    num? score,
    TData? member,
    bool? ch,
    bool? incr,
    bool? nx,
    bool? xx,
    CommandOption<dynamic, num?>? cmdOpts,
  }) {
    ScoreMember<TData>? scoreMember;
    if (score != null && member != null) {
      scoreMember = ScoreMember(score: score, member: member);
    }
    return ZAddCommand(
      key,
      [if (scoreMember != null) scoreMember],
      ch: ch,
      incr: incr,
      nx: nx,
      xx: xx,
      cmdOpts: cmdOpts,
    );
  }

  factory ZAddCommand(
    String key,
    List<ScoreMember<TData>> scoreMembers, {
    bool? ch,
    bool? incr,
    bool? nx,
    bool? xx,
    CommandOption<dynamic, num?>? cmdOpts,
  }) {
    if (nx != null && xx != null) {
      throw StateError('should only provide "nx" or "xx"');
    }

    final command = <dynamic>['zadd', key];

    if (nx == true) {
      command.add('nx');
    } else if (xx == true) {
      command.add('xx');
    }

    if (ch == true) {
      command.add('ch');
    }
    if (incr == true) {
      command.add('incr');
    }

    final flatScoreMap = scoreMembers.map((e) => [e.score, e.member]).flattened;
    command.addAll(flatScoreMap);

    return ZAddCommand._(command, cmdOpts);
  }

  @override
  Future<num?> exec(Requester client) async {
    final response = await client.request<dynamic>(body: command);
    final result = checkUpstashResponse<dynamic>(response);

    dynamic value = result;
    if (result is String) {
      value = num.tryParse(result);
    } else if (result is num) {
      value = result;
    }
    return deserialize(value);
  }
}
