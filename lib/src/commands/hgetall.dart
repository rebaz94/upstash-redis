import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/utils.dart';

Map<String, TData?>? _deserialize<TData>(List<String> result) {
  if (result.isEmpty) return null;

  final obj = <String, TData?>{};
  while (result.length >= 2) {
    final key = result.removeAt(0);
    final value = result.removeAt(0);

    try {
      obj[key] = parseResponse(value);
    } catch (_) {
      obj[key] = value as TData;
    }
  }

  return obj;
}

class HGetAllCommand<TData> extends Command<Object?, Map<String, TData?>?> {
  HGetAllCommand._(
    super.command,
    super.opts,
    super.deserialize,
  );

  /// Returns all fields and values of the hash stored at key
  ///
  /// The [TData] parameter work well if the values of the fields has same type.
  /// for example if you set value like this -> {'f1': 'a', 'f2': '123', 'f3': false} then it best to
  /// set [TData] as [Object] this way default deserializer will try to decode to
  /// {'f1': 'a', 'f2': 123, 'f3': false}.
  ///
  /// Note:
  /// * you can see that the field of `f2` converted to number but the original value is string,
  /// if you want to be a string, you can create a custom deserializer to convert back to string.
  ///
  /// * if set [TData] as [String] the original string will be returned from redis, so you can later
  /// deserializer your complex object.
  ///
  /// simple example of custom deserializer
  /// ```dart
  ///  final key = newKey();
  ///  await HSetCommand(key, {
  ///    'f1': false, 'f2': '12345', 'f3': 'rebaz',
  ///    'f4': {'v': 'me'}, 'f5': {'v': ['me2', 1]},
  ///  }).exec(client);
  ///
  ///  final res = await HGetAllCommand<Object>(key).exec(client);
  ///  expect(res, <String, dynamic>{
  ///    'f1': false, 'f2': 12345, 'f3': 'rebaz',
  ///    'f4': {'v': 'me'}, 'f5': {'v': ['me2', 1]}
  ///  });
  ///
  ///  // this custom deserialize used to prevent converting string number to string and
  ///  // convert true|false to bool, number to string,
  ///  final res2 = await HGetAllCommand<Object>(key, _getCustomDeserialize()).exec(client);
  ///  expect(res2, <String, dynamic>{
  ///    'f1': false, 'f2': '12345', 'f3': 'rebaz',
  ///    'f4': {'v': 'me'}, 'f5': {'v': ['me2', 1]}
  ///  });
  /// ```
  ///
  /// ```dart
  ///  CommandOption<Object?, Map<String, Object?>> _getCustomDeserialize() {
  ///   return CommandOption(
  ///     deserialize: (resultObj) {
  ///       final result = List<String>.from(resultObj as List);
  ///       if (result.isEmpty) return {};
  ///
  ///       final obj = <String, Object?>{};
  ///       while (result.length >= 2) {
  ///         final key = result.removeAt(0);
  ///         final value = result.removeAt(0);
  ///
  ///         try {
  ///           obj[key] = _parseValue(value);
  ///         } catch (_) {
  ///           obj[key] = value;
  ///         }
  ///       }
  ///
  ///       return obj;
  ///     },
  ///   );
  /// }
  ///
  /// Object? _parseValue(dynamic value) {
  ///   Object? parsed;
  ///   final isString = value is String;
  ///   if (isString && (parsed = num.tryParse(value)) != null) {
  ///     return parsed.toString();
  ///   } else if (parsed == 'false' || parsed == 'true') {
  ///     return parsed == 'false' ? false : true;
  ///   } else if (value is List) {
  ///     return value.map((o) {
  ///       try {
  ///         return _parseValue(o);
  ///       } catch (_) {
  ///         return o;
  ///       }
  ///     });
  ///   } else {
  ///     return json.decode(value as String);
  ///   }
  /// }
  /// ```
  factory HGetAllCommand(String key, [CommandOption<Object?, Map<String, TData?>>? opts]) {
    return HGetAllCommand._(
      ['hgetall', key],
      opts,
      (result) => _deserialize<TData>(List<String>.from(result as List)),
    );
  }
}
