namespace :db do
  desc 'Fill database with test data from a YAML file with a specific structure.'
  task populate_static: [:setup] do
    require 'faker'
    require 'factory_girl_rails'
    require 'yaml'

    @indent_level = 0

    def indent
      @indent_level += 1
    end

    def unindent
      @indent_level -= 1 unless @indent_level == 0
    end

    def print_indented(message)
      print '  ' * @indent_level
      puts message
    end

    def create_user_and_profile(user_info, fill_blanks)
      if fill_blanks
        user_info['salutation']           ||= 'Dr.'
        user_info['first_name']           ||= Faker::Name.first_name
        user_info['last_name']            ||= Faker::Name.last_name
        user_info['superuser']            ||= false
        user_info['date_of_birth']        ||= 20.years.ago - rand(20.years)
        user_info['email']                ||= Faker::Internet.email
        user_info['password']             ||= 'password'
        user_info['home_phone']           ||= Faker::PhoneNumber.phone_number
        user_info['mobile_phone']         ||= Faker::PhoneNumber.phone_number
        user_info['characteristics']      ||= ''
        user_info['avoid_for']            ||= ''
        user_info['avatar_url']           ||= 'https://s3-ap-southeast-2.amazonaws.com/prompa-development/static/placeholder/avatar/avatar-default-300x300.jpg'
      end

      # Default to phone_business_hours for the password. If phone_business_hours is nil, fail hard.
      unless user_info['password']
        user_info['password'] = if !Rails.env.development?
          user_info['phone_number'].gsub(' ', '')
        else
          'password'
        end
      end

      # Print pretty messages
      print_indented "=> Creating user #{user_info['first_name']} #{user_info['last_name']} (#{user_info['email']})..."
      indent

      user = User.create!(
        email:                 user_info['email'],
        superuser:             user_info['superuser'],
        password:              user_info['password'],
        password_confirmation: user_info['password']
      )

      user.add_profile(
        salutation:    user_info['salutation'],
        first_name:    user_info['first_name'],
        last_name:     user_info['last_name'],
        gender:        'Unspecified',
        date_of_birth: user_info['date_of_birth'],
        phone_number:  user_info['phone_number'],
        address_id:    user_info['address'].present? ? create_address(user_info['address'], fill_blanks).id : nil,
        avatar:        URI.parse(user_info['avatar_url'])
      )

      unindent

      user
    end

    def create_address(address_info, fill_blanks)
      if fill_blanks
        address_info['street_address'] ||= Faker::Address.street_address
        address_info['suburb']         ||= Faker::Address.city
        address_info['state']           ||= Faker::Address.state
        address_info['postcode']       ||= Faker::Address.postcode
        address_info['country']         ||= Faker::Address.country
      end

      # Print pretty messages
      print_indented "=> Creating address '#{address_info['street_address']}, #{address_info['suburb']}, #{address_info['state']}, #{address_info['country']}, #{address_info['postcode']}'..."

      # Create the address
      address = Address.create(
        street_address: address_info['street_address'],
        suburb:         address_info['suburb'],
        state:          address_info['state'],
        postcode:       address_info['postcode'],
        country:        address_info['country']
      )

      address
    end

    def create_location(location_info, fill_blanks)
      if fill_blanks
        location_info['name'] ||= Faker::Address.city
      end

      # Print pretty messages
      print_indented "=> Creating location '#{location_info['name']}'"
      indent

      # Create the location
      location = Location.create(
        name:       location_info['name'],
        address_id: create_address(location_info['address'], fill_blanks).id,
        latitude:   location_info['latitude'],
        longitude:  location_info['longitude']
      )

      unindent

      location
    end

    # Ensure the user has passed a valid YAML filename, and fail if not.
    input_file = nil
    begin
      raise if ENV['file'].nil?
      input_file = YAML::load_file(ENV['file'])
    rescue => err
      if ENV['file'].nil?
        puts "\n\nERROR: Input filename not specified."
        puts 'Usage: rake db:populate_static file=path/to/your/yaml/file.yml'
      else
        puts "\n\nERROR: Input file \"#{ENV['file']}\" invalid or not found."
      end

      puts err
      exit
    end

    puts "\n---[ Populating database with mock data from #{ENV['file']}... ]---\n\n"

    import_data = input_file['import_data']
    fill_blanks = import_data['fill_blanks']

    # Extract main sections.
    users         = import_data['users']

    # Populate users
    users.each do |user_key, user_info|
      create_user_and_profile(user_info, fill_blanks)
    end

    puts "\nDonezzzzz..."
  end
end
