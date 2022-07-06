import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/utils.dart';

Map<String, TData>? _deserialize<TData>(List<String> fields, List<String?> result) {
  if (result.isEmpty || result.every((field) => field == null)) {
    return null;
  }

  final obj = <String, TData>{};
  for (int i = 0; i < fields.length; i++) {
    final value = result[i];

    try {
      obj[fields[i]] = parseResponse(value);
    } catch (_) {
      obj[fields[i]] = value as TData;
    }
  }

  return obj;
}

class HMGetCommand<TData> extends Command<List<Object?>, Map<String, TData?>?> {
  HMGetCommand._(
    super.command,
    super.opts,
    super.deserialize,
  );

  /// Returns the values associated with the specified fields in the hash stored at key
  ///
  /// The [TData] parameter work well if the values of the fields has same type.
  /// for example if you set value like this -> {'f1': 'a', 'f2': '123', 'f3': false} then it best to
  /// set [TData] as [Object] or [dynamic] this way default deserializer will try to decode to
  /// {'f1': 'a', 'f2': '123', 'f3': false}.
  ///
  /// Note:
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
  ///  final fields = ['f1', 'f2', 'f3', 'f4', 'f5', 'f6'];
  ///  final res = await HMGetCommand<Object>(key, fields).exec(client);
  ///  expect(res, <String, dynamic>{
  ///    'f1': false, 'f2': '12345', 'f3': 'rebaz',
  ///    'f4': {'v': 'me'}, 'f5': {'v': ['me2', 1]}
  ///  });
  ///
  ///  // this custom deserialize used to convert stringifies number to number
  ///  final res2 = await HMGetCommand<Object?>(key, fields, _getCustomDeserialize(fields)).exec(client);
  ///  expect(res2, <String, dynamic>{
  ///    'f1': false, 'f2': 12345, 'f3': 'rebaz',
  ///    'f4': {'v': 'me'}, 'f5': {'v': ['me2', 1]}
  ///  });
  /// ```
  ///
  /// ```dart
  ///  CommandOption<List<Object?>, Map<String, Object?>?> _getCustomDeserialize(List<String> fields) {
  ///   return CommandOption(
  ///     deserialize: (resultObj) {
  ///       final result = resultObj;
  ///       if (result.isEmpty || result.every((field) => field == null)) {
  ///         return null;
  ///       }
  ///
  ///       final obj = <String, Object?>{};
  ///       for (int i = 0; i < fields.length; i++) {
  ///         final value = result[i];
  ///
  ///         try {
  ///           obj[fields[i]] = _parseValue(value);
  ///         } catch (_) {
  ///           obj[fields[i]] = value;
  ///         }
  ///       }
  ///
  ///       return obj;
  ///     },
  ///   );
  /// }
  ///
  /// Object? _parseValue(dynamic value) {
  ///   if (value is num || value is bool) return value;
  ///
  ///   if (value is List) {
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
  factory HMGetCommand(
    String key,
    List<String> fields, [
    CommandOption<List<Object?>, Map<String, TData?>?>? opts,
  ]) {
    return HMGetCommand._(
      [
        'hmget',
        key,
        ...fields,
      ],
      opts,
      (result) => _deserialize<TData>(
        fields,
        result.cast<String?>(),
      ),
    );
  }
}
