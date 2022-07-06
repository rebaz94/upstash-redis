import 'dart:convert';

import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/hmget.dart';
import 'package:upstash_redis/src/commands/hmset.dart';
import 'package:upstash_redis/src/commands/hset.dart';
import 'package:upstash_redis/src/test_utils.dart';
import 'package:upstash_redis/src/utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('hmget gets exiting values', () async {
    final key = newKey();
    final field1 = randomID();
    final field2 = randomID();
    final field3 = randomID();
    final value1 = '123';
    final value2 = '456';
    final value3 = 'rebaz';
    final res =
        await HMSetCommand(key, {field1: value1, field2: value2, field3: value3}).exec(client);
    expect(res, 'OK');

    final res2 = await HMGetCommand(key, [field1, field2, field3, 'notExist']).exec(client);
    expect(res2, {field1: '123', field2: '456', field3: 'rebaz', 'notExist': null});
  });

  test('when the hash does not exist, returns null', () async {
    final key = newKey();
    final res = await HMGetCommand(key, [randomID()]).exec(client);
    expect(res, null);
  });

  test('gets an object', () async {
    final key = newKey();
    final field = randomID();
    final value = {'v': randomID()};
    await HMSetCommand(key, {field: value}).exec(client);

    final res2 = await HMGetCommand(key, [field]).exec(client);
    expect(res2, {field: value});
  });

  test('get an object with custom deserializer', () async {
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

    final fields = [field1, field2, field3, field4, field5, field6];

    final res = await HMGetCommand<Object?>(key, fields).exec(client);
    expect(res?.sorted(), <String, dynamic>{
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

    // this custom deserialize used to convert stringifies number to number
    final res2 = await HMGetCommand<Object?>(
      key,
      fields,
      _getCustomDeserialize(fields),
    ).exec(client);
    expect(res2?.sorted(), <String, dynamic>{
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

CommandOption<List<Object?>, Map<String, Object?>?> _getCustomDeserialize(List<String> fields) {
  return CommandOption(
    deserialize: (resultObj) {
      final result = resultObj;
      if (result.isEmpty || result.every((field) => field == null)) {
        return null;
      }

      final obj = <String, Object?>{};
      for (int i = 0; i < fields.length; i++) {
        final value = result[i];

        try {
          obj[fields[i]] = _parseValue(value);
        } catch (_) {
          obj[fields[i]] = value;
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
