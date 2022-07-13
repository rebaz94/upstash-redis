# Upstash Redis

`@upstash/redis` is an HTTP/REST based Redis client for dart, built on top
of [Upstash REST API](https://docs.upstash.com/features/restapi).

This Dart package mirrors the design of official upstash-redis typescript library. Find the documentation [here](https://github.com/upstash/upstash-redis).

It is the only connectionless (HTTP based) Redis client and designed for:

- Serverless functions (AWS Lambda ...)
- Cloudflare Workers 
- Fastly Compute@Edge 
- Client side web/mobile applications
- WebAssembly
- and other environments where HTTP is preferred over TCP.

See
[the list of APIs](https://docs.upstash.com/features/restapi#rest---redis-api-compatibility)
supported.

## Quick Start

### Install

```bash
dart pub add upstash_redis
```

### Create database

Create a new redis database on [upstash](https://console.upstash.com/)

## Basic Usage:

```dart
import 'package:upstash_redis/upstash_redis.dart';

void main() async {
  const redis = new Redis(
    url: '<UPSTASH_REDIS_REST_URL>',
    token: '<UPSTASH_REDIS_REST_TOKEN>',
  );

  // string
  await redis.set('key', 'value');
  final value1 = await redis.get('key');
  print(value1);

  await redis.set('key2', 'value2', ex: 1);

  // sorted set
  await redis.zadd('scores', score: 1, member: 'team1');
  final value2 = await redis.zrange('scores', 0, 100);
  print(value1);

  // list
  await redis.lpush('elements', ['magnesium']);
  final value3 = await redis.lrange('elements', 0, 100);
  print(value3);

  // hash
  await redis.hset('people', {'name': 'joe'});
  final value4 = await redis.hget('people', 'name');
  print(value4);

  // sets
  await redis.sadd('animals', ['cat']);
  final value5 = await redis.spop<String>('animals', 1);
  print(value5);
}
```

## Contributing

- Fork the repo on [GitHub](https://github.com/rebaz94/upstash-redis)
- Clone the project to your own machine
- Commit changes to your own branch
- Push your work back up to your fork
- Submit a Pull request so that we can review your changes and merge

## License

This repo is licenced under MIT.

## Credits

- https://github.com/upstash/upstash-redis/