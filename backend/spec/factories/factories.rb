FactoryGirl.define do
  factory :address do
    street_address { Faker::Address.street_address }
    suburb         { Faker::Address.city }
    postcode       { Faker::Address.postcode }
    state          { Faker::Address.state }
    country        { Faker::Address.country }
  end

  factory :location do
    association :address, factory: :address

    longitude { Faker::Address.longitude  }
    latitude  { Faker::Address.latitude   }
    timezone  { Faker::Address.time_zone  }
  end

  factory :log do
    user
    level      ['debug', 'info', 'warn', 'error', 'fatal'].sample
    category   ['controller', 'model', 'auth'].sample              # @TODO: Figure out what these will be and where they will come from
    message    { "#{Faker::Lorem.sentences(1)}." }
    controller Rails.application.routes.routes.map{|r| r.defaults[:controller] }.reject{|r| r.nil?}.to_a.sample
    action     ['index', 'show', 'create', 'update', 'delete'].sample
    data       { build(:user).to_json }
    notes      { Faker::Lorem.sentences(1) }
  end

  factory :profile do
    user            { FactoryGirl.build_stubbed(:user, create_profile: false)}
    address
    first_name      { Faker::Name.first_name }
    preferred_name  { Faker::Name.first_name }
    last_name       { Faker::Name.last_name }
    phone_number    { Faker::PhoneNumber.phone_number }
    date_of_birth   { Time.random(year_range: 50) }
    email           { |p| p.user.email }
    last_active     2.days.ago
    gender          [ 'Male', 'Female' ].sample
  end

  factory :user, aliases: [:author, :reviewer]  do
    transient do
      create_profile false
      first_name     'Factory'
      last_name      'Felix'
    end

    sequence(:email)      { |n| "email#{n}@factory.com" }
    initialize_with       { User.find_or_create_by(email: email)}
    password              'password'
    password_confirmation { |user| user.password }
    encrypted_password    { |user| BCrypt::Password.create(user.password) }
    superuser             false

    trait :superuser do
      superuser true
    end

    after(:create) do |user, evaluator|
      if evaluator.create_profile
        FactoryGirl.create(:profile,
          user:       user,
          first_name: evaluator.first_name,
          last_name:  evaluator.last_name
        )
      end
    end
  end
end
