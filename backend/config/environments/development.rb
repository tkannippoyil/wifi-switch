InterfaceApi::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # @TODO: Shouldn't use this in dev
  config.action_mailer.delivery_method = :ses

  # GCM API key
  config.gcm_key      = ''
  config.gcm_app_name = 'android_app'

  config.send_notifications = false

  # Paperclip path config
  Paperclip.options[:command_path] = '/usr/local/bin/'


  # For development, setting environment variables
  ENV['FRONTEND_WEBSITE_URL']  = 'http://localhost:9000'

  ENV['S3_BUCKET_NAME']        = 'temp-app-development'
  ENV['AWS_ACCESS_KEY_ID']     = ''
  ENV['AWS_SECRET_ACCESS_KEY'] = ''

  # base url
  Rails.application.routes.default_url_options = { host: 'http://localhost:3000' }
end
