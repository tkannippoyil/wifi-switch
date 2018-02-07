redis_url = ENV["REDISCLOUD_URL"] || 'redis://localhost:6379/0/cache'
uri = URI.parse redis_url

$redis = Redis::Namespace.new(
  'temp-app',
  redis: Redis.new(
    host: uri.host, port: uri.port, password: uri.password
  )
)
