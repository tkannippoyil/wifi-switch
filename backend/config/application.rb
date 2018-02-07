require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module InterfaceApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.active_job.queue_adapter = :resque

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Do not initialize on precompile
    config.assets.initialize_on_precompile = false

    config.autoload_paths += %W(
      #{config.root}/lib
      #{config.root}/app/actions
      #{config.root}/app/caches
      #{config.root}/app/notifiers
    )

    # Check that all environment variables required for the application to function are set.
    required_env_vars = ['FRONTEND_WEBSITE_URL']
    config.before_initialize do
      required_env_vars.each do |var|
        raise "ENV['#{var}'] is not set." unless ENV.has_key? var
      end
    end

    config.to_prepare do
      DeviseController.respond_to :json
    end

    config.middleware.insert_before Warden::Manager, Rack::Cors do
      allow do
        origins '*'
        resource '*',
        headers: :any,
        methods: [:get, :post, :put, :delete, :options]
      end
    end

    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    config.after_initialize do
      config.paperclip_defaults = {
        storage:        :s3,
        s3_host_name:   's3-ap-southeast-2.amazonaws.com',
        s3_protocol:    :https,
        s3_credentials: {
          bucket:            ENV['S3_BUCKET_NAME'],
          access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        }
      }

      ::SETTINGS = YAML.load_file(File.join(Rails.root, 'config/settings.yml'))[Rails.env]
    end
  end
end
