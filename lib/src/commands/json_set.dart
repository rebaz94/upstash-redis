import 'package:upstash_redis/src/commands/command.dart';

class JsonSetCommand<TData> extends Command<String?, String?> {
  JsonSetCommand._(super.command, super.opts);

  factory JsonSetCommand(
    String key,
    String path,
    TData value, {
    bool? nx,
    bool? xx,
    CommandOption<String?, String?>? opts,
  }) {
    if (nx == true && xx == true) {
      throw StateError('must provide one option only, nx or xx');
    }

    return JsonSetCommand._(
      [
        'JSON.SET',
        key,
        path,
        value,
        if (nx == true) 'NX',
        if (xx == true) 'XX',
      ],
      opts,
    );
  }
}
