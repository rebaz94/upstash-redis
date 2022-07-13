import 'package:upstash_redis/src/commands/command.dart';
import 'package:collection/collection.dart';

enum ValueType {
  string('string'),
  list('list'),
  set('set'),
  zset('zset'),
  hash('hash'),
  none('none');

  const ValueType(this.value);

  final String value;
}

class TypeCommand extends Command<String, ValueType> {
  TypeCommand._(super.command, super.opts, super.deserialize);

  factory TypeCommand(String key, [CommandOption<String, ValueType>? opts]) {
    return TypeCommand._(
      ['type', key],
      opts,
      (result) {
        return ValueType.values.firstWhereOrNull((e) => e.name == result) ??
            ValueType.none;
      },
    );
  }
}
