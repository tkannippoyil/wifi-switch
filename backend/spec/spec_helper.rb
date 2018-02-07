# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'active_support/all'
require 'simplecov'
require 'rspec/rails'
# --- @ADD_TO_BOOTSTRAPPER ---
# Commented this out to stop errors with Zeus. Should have no real impact: https://www.relishapp.com/rspec/rspec-core/docs/command-line
# require 'rspec/autorun'
# ---

SimpleCov.start 'rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # --- @ADD_TO_BOOTSTRAPPER ---
  # Configure to use FactoryGirl and Devise
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  # ---

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # --- @ADD_TO_BOOTSTRAPPER ---
  # Enables selective testing via the :focus and :slow tags - see http://railscasts.com/episodes/413-fast-tests
  # config.treat_symbols_as_metadata_keys_with_true_values = true
  # config.filter_run focus: true
  # config.run_all_when_everything_filtered = true
  # config.filter_run_excluding :slow unless ENV["RUN_SLOW_SPECS"]
  # config.filter_run_excluding :continuous_integration_only unless ENV["RUN_CI_SPECS"]

  # Customises Ruby garbage collection behaviour so that it doesn't slow down running tests
  config.before(:all) { DeferredGarbageCollection.start }
  config.after(:all)  { DeferredGarbageCollection.reconsider }
  # ---
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec
    # with.test_framework :minitest
    # with.test_framework :minitest_4
    # with.test_framework :test_unit

    # Choose one or more libraries:
    # with.library :active_record
    # with.library :active_model
    # with.library :action_controller
    # Or, choose the following (which implies all of the above):
    with.library :rails
  end
end
