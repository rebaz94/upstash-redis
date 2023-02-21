import 'package:upstash_redis/src/redis.dart';

/// Creates a new script.
///
/// Scripts offer the ability to optimistically try to execute a script without having to send the
/// entire script to the server. If the script is loaded on the server, it tries again by sending
/// the entire script. Afterwards, the script is cached on the server.
///
/// @example
/// ```dart
/// final redis = Redis();
/// final scriptSource = "return ARGV[1];";
/// final scriptSha1 = sha1.convert(utf8.encode(scriptSource)).toString(); // generate using crypto package
/// final script = redis.createScript<string>(scriptSource, scriptSha1);
/// final arg1 = await script.eval([], ["Hello World"]);
/// assert(arg1 == "Hello World");
/// ```
class Script<T> {
  final Redis redis;
  final String script;
  final String sha1;

  Script(this.redis, this.script, this.sha1);

  /// Send an `EVAL` command to redis.
  Future<T> eval<TArgs>(List<String> keys, List<TArgs> args) async {
    return await redis.eval<TArgs, T>(script, keys, args);
  }

  /// Calculates the sha1 hash of the script and then calls `EVALSHA`.
  Future<T> evalsha<TArgs>(List<String> keys, List<TArgs> args) async {
    return await redis.evalsha<TArgs, T>(sha1, keys, args);
  }

  /// Optimistically try to run `EVALSHA` first.
  /// If the script is not loaded in redis, it will fall back and try again with `EVAL`.
  ///
  /// Following calls will be able to use the cached script
  Future<T> exec<TArgs>(List<String> keys, List<TArgs> args) async {
    try {
      final res = await redis.evalsha<TArgs, T>(sha1, keys, args);
      return res;
    } catch (e) {
      if (e.toString().toLowerCase().contains('noscript')) {
        return await eval<TArgs>(keys, args);
      } else {
        rethrow;
      }
    }
  }
}
