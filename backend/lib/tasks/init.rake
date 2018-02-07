  namespace :db do

  desc 'Init database with core users'
  task init: [:setup] do
    require 'faker'
    require 'factory_girl_rails'

    users = {
      admin: {
        email:     'admin@gmail.com',
        profile:   {first_name: 'Super', last_name: 'User'},
        superuser: true,
        password:  'Admin123'
      }
    }

    # Create users
    users.each do |user_key, user_info|
      user = FactoryGirl.create(:user,
        email:                 user_info[:email],
        password:              user_info[:password] || 'password',
        password_confirmation: user_info[:password] || 'password',
        superuser:             user_info[:superuser],
        create_profile:        true,
        first_name:            user_info[:profile][:first_name],
        last_name:             user_info[:profile][:last_name]
      )
    end
  end
end
