unless ENV['RAILS_ENV'] == 'test'
  require 'resque/tasks'
  require 'resque/scheduler/tasks'

  task 'resque:setup' => :environment do
    require 'resque'
    require 'resque/scheduler'
    require 'resque/scheduler/server'
    require 'resque/server'
    require 'active_scheduler'
    # This fixes `PG::Error: ERROR: prepared statement "a1" already exists`
    # Super cool props go to this rogue over at SO
    # http://stackoverflow.com/questions/10170807/activerecordstatementinvalid-pg-error
    Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }

    yaml_schedule    = YAML.load_file("#{Rails.root}/config/resque_schedule.yml") || {}
    wrapped_schedule = ActiveScheduler::ResqueWrapper.wrap yaml_schedule
    Resque.schedule  = wrapped_schedule
  end
end
