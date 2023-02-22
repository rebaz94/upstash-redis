import 'dart:convert';

import 'package:test/test.dart';
import 'package:upstash_redis/src/commands/command.dart';
import 'package:upstash_redis/src/commands/getdel.dart';
import 'package:upstash_redis/src/commands/set.dart';
import 'package:upstash_redis/src/test_utils.dart';

void main() async {
  final client = newHttpClient();
  final keygen = Keygen();
  final newKey = keygen.newKey;

  tearDownAll(() => keygen.cleanup());

  test('gets an exiting value, then deletes', () async {
    final key = newKey();
    final value = randomID();
    await SetCommand(key, value).exec(client);

    final res = await GetDelCommand<String>(key).exec(client);
    expect(res, value);

    final res2 = await GetDelCommand(key).exec(client);
    expect(res2, null);
  });

  test('gets a non-existing value', () async {
    final key = newKey();

    final res = await GetDelCommand<String>(key).exec(client);
    expect(res, null);
  });

  test('gets an object', () async {
    final key = newKey();
    final value = {'v': randomID()};
    await SetCommand(key, value).exec(client);

    final res = await GetDelCommand<Map<String, String>>(key).exec(client);
    expect(res, value);
  });

  test('gets a custom model', () async {
    final key = newKey();
    final value = _TestModel('Rebe', 29);
    await SetCommand(key, value.toJson()).exec(client);

    final res = await GetDelCommand<_TestModel>(
      key,
      CommandOption(
        deserialize: (result) {
          final decoded = json.decode(result as String) as Map<String, dynamic>;
          return _TestModel.fromJson(decoded);
        },
      ),
    ).exec(client);

    expect(res, value);
  });
}

class _TestModel {
  _TestModel(this.name, this.age);

  factory _TestModel.fromJson(Map<String, dynamic> json) {
    return _TestModel(
      json['name'] as String,
      json['age'] as int,
    );
  }

  final String name;
  final int age;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TestModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}
