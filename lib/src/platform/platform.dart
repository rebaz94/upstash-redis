import 'io_platform.dart' if (dart.library.html) 'web_platform.dart';

abstract class PlatformEnv {
  // ignore: unused_element
  const PlatformEnv._();

  static final PlatformEnv _platform = getPlatform();

  factory PlatformEnv() => _platform;

  String? operator [](String key);
}
