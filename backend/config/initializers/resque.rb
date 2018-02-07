unless ENV['RAILS_ENV'] == 'test'
  Dir[File.join(Rails.root, 'app', 'jobs', '*.rb')].each { |file| require file }

  if ENV['REDISCLOUD_URL']
    uri = URI.parse(ENV['REDISCLOUD_URL'])
    Resque.redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
  else
    config = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]
    if config
      Resque.redis = Redis.new(host: config['host'], port: config['port'])
    end
  end
end
