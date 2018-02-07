namespace :populate_default_values do
  desc 'Populate Notification settings'
  task notification_settings: :environment do

    # Android device notification settings
    app_name = RailsApiBase::Application.config.gcm_app_name
    app = Rpush::Gcm::App.find_by_name(app_name)
    unless app
      puts 'creating GCM notification settings'

      app = Rpush::Gcm::App.new
      app.name        = app_name
      app.auth_key    = RailsApiBase::Application.config.gcm_key
      app.connections = 1
      app.save!
    end

    # IPhone device notification settings
    config = YAML.load_file(File.join(Rails.root, 'config/apns.yml'))[Rails.env]

    app = Rpush::Apns::App.find_by_name(config['app_name'])
    unless app
      puts 'creating Apns notification settings'

      app = Rpush::Apns::App.new
      app.name = config['app_name']
      app.certificate = File.read(File.join(
        Rails.root, 'lib/apns', config['certificate']
      ))
      app.environment = config['environment']
      app.password    = config['passphrase']
      app.connections = 1
      app.save!
    end
  end
end
