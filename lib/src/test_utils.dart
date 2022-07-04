import 'dart:io';
import 'dart:math' as math;

import 'package:upstash_redis/src/commands/del.dart';
import 'package:upstash_redis/src/http.dart';

final _random = math.Random();

String randomID() {
  return _random.nextInt(10000000).toString();
}

UpstashHttpClient newHttpClient() {
  final url = Platform.environment['UPSTASH_REDIS_REST_URL'];
  final token = Platform.environment['UPSTASH_REDIS_REST_TOKEN'];

  if (url == null) {
    throw StateError('Could not find url');
  }

  if (token == null) {
    throw StateError('Could not find token');
  }

  return UpstashHttpClient(
    HttpClientConfig(
      baseUrl: url,
      headers: {
        'authorization': 'Bearer $token',
      },
    ),
  );
}

class Keygen {
  final List<String> keys = [];

  String newKey() {
    final key = randomID();
    keys.add(key);
    return key;
  }

  Future<void> cleanup() async {
    if (keys.isNotEmpty) {
      await DelCommand(keys).exec(newHttpClient());
    }
  }
}
