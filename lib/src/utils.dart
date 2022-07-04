import 'dart:convert';

import 'package:upstash_redis/src/converters.dart';

TResult parseResponse<TResult>(dynamic result) {
  try {
    // return as soon as you know its the correct format
    // node: if we remove this line below,
    // it will try to parse -> may throw exception -> force casted
    if (result is TResult) return result;

    final resultType = TResult.toString().replaceAll('?', '');
    final value = parseRecursive(result);

    if (value is Map) {
      final converter = mapConversions[resultType];
      if (converter != null) {
        return converter.call(value) as TResult;
      }
    } else if (value is List) {
      final converter = listConversions[resultType];
      if (converter != null) {
        return converter.call(value) as TResult;
      }
    }

    return value as TResult;
  } catch (e) {
    return result as TResult;
  }
}

dynamic parseRecursive(dynamic obj) {
  final parsed = obj is List
      ? obj.map((o) {
          try {
            return parseRecursive(o);
          } catch (_) {
            return o;
          }
        }).toList()
      : json.decode(obj as String);

  // Parsing very large numbers can result in MAX_SAFE_INTEGER
  // overflow. In that case we return the number as string instead.
  if (parsed is num && parsed.toString() != obj) {
    return obj;
  }

  return parsed;
}
