import 'package:upstash_redis/src/commands/command.dart';

class ZUnionStoreCommand extends Command<int, int> {
  ZUnionStoreCommand._(super.command, super.opts);

  factory ZUnionStoreCommand.single(
    String destination,
    String key, {
    AggregateType? aggregate,
    int? weight,
    List<int>? weights,
    CommandOption<int, int>? opts,
  }) {
    return ZUnionStoreCommand(
      destination,
      1,
      [key],
      aggregate: aggregate,
      weight: weight,
      weights: weights,
      opts: opts,
    );
  }

  factory ZUnionStoreCommand(
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

    final command = ['zunionstore', destination, numKeys, ...keys];
    if (weight != null) {
      command.addAll(['weights', weight]);
    } else if (weights != null) {
      command.addAll(['weights', ...weights]);
    }

    if (aggregate != null) {
      command.addAll(['aggregate', aggregate.value]);
    }

    return ZUnionStoreCommand._(command, opts);
  }
}
