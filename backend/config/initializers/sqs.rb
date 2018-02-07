if Rails.env.in? %w(development test)
  $queue = nil
else
  config = YAML.load_file(File.join(Rails.root, 'config/sqs.yml'))[Rails.env]

  sqs = AWS::SQS.new(
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:            config['region']
  )

  $queue = sqs.queues.named config['queue']
end

