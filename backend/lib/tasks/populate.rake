namespace :db do

  desc 'Fill database with test data'
  task populate: [ :create, :migrate ] do
    require 'faker'
    require 'factory_girl_rails'

    # @TODO: YAMLify this...
    users = {
      worker: {
        email: 'worker@agency.com',
        profile: {first_name: 'Worker', last_name: 'Wally', gender: 'Male'},
        superuser: false
      }
    }

    # Create users
    users.each do |user_key, user_info|
      user = FactoryGirl.create(:user,
        email:          user_info[:email],
        superuser:      user_info[:superuser],
        create_profile: true,
        first_name:     user_info[:profile][:first_name],
        last_name:      user_info[:profile][:last_name]
      )
    end
  end
end
