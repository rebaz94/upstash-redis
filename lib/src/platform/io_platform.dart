import 'dart:io';

import 'package:upstash_redis/src/platform/platform.dart';

class IOPlatform implements PlatformEnv {
  const IOPlatform();

  @override
  String? operator [](String key) => Platform.environment[key];
}

PlatformEnv getPlatform() => const IOPlatform();
