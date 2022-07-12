import 'package:upstash_redis/src/commands/command.dart';

enum AggregateType {
  sum('sum'),
  min('min'),
  max('max');

  final String value;

  const AggregateType(this.value);
}

class ZInterStoreCommand extends Command<int, int> {
  ZInterStoreCommand._(super.command, super.opts);

  factory ZInterStoreCommand.single(
    String destination,
    String key, {
    AggregateType? aggregate,
    int? weight,
    List<int>? weights,
    CommandOption<int, int>? opts,
  }) {
    return ZInterStoreCommand(
      destination,
      1,
      [key],
      aggregate: aggregate,
      weight: weight,
      weights: weights,
      opts: opts,
    );
  }

  factory ZInterStoreCommand(
    String destination,
    int numKeys,
    List<String> keys, {
    AggregateType? aggregate,
    int? weight,
    List<int>? weights,
    CommandOption<int, int>? opts,
  }) {
    if (weight != null && weights != null) {
      throw StateError('it should provide only weight or weights');
    }

    final command = ['zinterstore', destination, numKeys, ...keys];
    if (weight != null) {
      command.addAll(['weights', weight]);
    } else if (weights != null) {
      command.addAll(['weights', ...weights]);
    }

    if (aggregate != null) {
      command.addAll(['aggregate', aggregate.value]);
    }

    return ZInterStoreCommand._(command, opts);
  }
}
