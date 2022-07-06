import 'dart:convert';

import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/hgetall.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/test_utils.dart';
import 'package:upstash_redis/src/utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('returns all fields', () async {
    final key = newKey();
    final field1 = 'f1';
    final field2 = 'f2';
    final field3 = 'f3';
    final field4 = 'f4';
    final field5 = 'f5';
    final field6 = 'f6';
    final value1 = false;
    final value2 = '12345';
    final value3 = 'rebaz';
    final value4 = {'v': 'me'};
    final value5 = {
      'v': ['me2', 1]
    };
    final value6 = {
      'v': ['1', '2']
    };
    await HSetCommand(key, {
      field1: value1,
      field2: value2,
      field3: value3,
      field4: value4,
      field5: value5,
      field6: value6,
    }).exec(client);

    final res = await HGetAllCommand<Object>(key).exec(client);
    expect(res, <String, dynamic>{
      field1: false,
      field2: '12345',
      field3: 'rebaz',
      field4: {'v': 'me'},
      field5: {
        'v': ['me2', 1]
      },
      field6: {
        'v': ['1', '2']
      },
    });

    final res2 = await HGetAllCommand<String>(key).exec(client);
    expect(res2?.sorted(), <String, dynamic>{
      field1: 'false',
      field2: '12345',
      field3: 'rebaz',
      field4: '{"v":"me"}',
      field5: '{"v":["me2",1]}',
      field6: '{"v":["1","2"]}',
    });

    // this custom deserialize used to prevent converting string number to string and
    // convert true|false to bool, number to string,
    final res3 = await HGetAllCommand<Object>(key, _getCustomDeserialize()).exec(client);
    expect(res3, <String, dynamic>{
      field1: false,
      field2: 12345,
      field3: 'rebaz',
      field4: {'v': 'me'},
      field5: {
        'v': ['me2', 1]
      },
      field6: {
        'v': ['1', '2']
      },
    });
  });
}

CommandOption<Object?, Map<String, Object?>> _getCustomDeserialize() {
  return CommandOption(
    deserialize: (resultObj) {
      final result = List<String>.from(resultObj as List);
      if (result.isEmpty) return {};

      final obj = <String, Object?>{};
      while (result.length >= 2) {
        final key = result.removeAt(0);
        final value = result.removeAt(0);

        try {
          obj[key] = _parseValue(value);
        } catch (_) {
          obj[key] = value;
        }
      }

      return obj;
    },
  );
}

Object? _parseValue(dynamic value) {
  if (value is num || value is bool) return value;

  if (value is List) {
    return value.map((o) {
      try {
        return _parseValue(o);
      } catch (_) {
        return o;
      }
    });
  } else {
    return json.decode(value as String);
  }
}
