import 'dart:convert';

import 'package:upstash_redis/src/converters.dart';

Type _get<T>() => T;
final _types = [_get<dynamic>().toString(), _get<Object>().toString()];

TResult parseResponse<TResult>(dynamic result) {
  try {
    final resultType = TResult.toString().replaceAll('?', '');
    if (!_types.contains(resultType) && result is TResult) {
      return result;
    }

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
  if (obj is String && num.tryParse(obj) != null) {
    return obj;
  } else if (obj is bool) {
    return obj;
  } else if (obj is List) {
    return obj.map((o) {
      try {
        return parseRecursive(o);
      } catch (_) {
        return o;
      }
    });
  } else {
    return json.decode(obj as String);
  }

  // final parsed = obj is List
  //     ? obj.map((o) {
  //         try {
  //           return parseRecursive(o);
  //         } catch (_) {
  //           return o;
  //         }
  //       }).toList()
  //     : json.decode(obj as String);
  //
  // // Parsing very large numbers can result in MAX_SAFE_INTEGER
  // // overflow. In that case we return the number as string instead.
  // if (parsed is num && parsed.toString() != obj) {
  //   return obj;
  // }
  //
  // return parsed;
}


extension MapX<K,V> on Map<K, V> {

  Map<K, V> sorted() {
    final keys = this.keys.toList()..sort();
    final sorted = <K, V>{};
    for (final e in keys) {
      // ignore: null_check_on_nullable_type_parameter
      sorted[e] = this[e]!;
    }
    return sorted;
  }

}