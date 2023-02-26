import 'package:upstash_redis/upstash_redis.dart';

Future<void> main() async {
  final redis = Redis.fromEnv();

  print(await redis.set('name', 'rebaz', ex: 60));
  print(await redis.set(
    'obj',
    {
      'v': {
        'a': [1, 2],
        'b': [3, 4]
      }
    },
    ex: 60,
  ));
  print(await redis.get<String>('name'));
  print(await redis.get<Map<String, Map<String, List<int>>>>('obj'));
  print(await redis.set('name', 'raouf', ex: 60, nx: true));
  print(await redis.zadd('z', score: 1, member: 'rebaz'));
  print(await redis.zadd(
    'z2',
    scores: [
      ScoreMember(score: 2, member: 'Mike'),
      ScoreMember(score: 3, member: 'Ali'),
      ScoreMember(score: 4, member: 'Jack'),
    ],
  ));
  print(await redis.zrem('z2', ['Jack', 'Ali']));
  print(await redis.json
      .set('json', $, {'counter': 1, 'hello': '', 'name': 're'}));
  print(await redis.json.numincrby('json', r'$.counter', 1));
  print(await redis.json.set('json', r'$.hello', '"world"'));
  print(await redis.json.strappend('json', r'$.name', '"baz"'));
  print(await redis.json.strlen('json', r'$.name'));
  print(await redis.json.get('json', [r'$.name']));
  redis.close();
}
