class CreateUserAction
  def initialize(user_options)
    @user_options = user_options
  end

  def perform
    @user = create_user

    create_profile(@user_options[:profile]) unless @user.profile.present?

    @user
  end

  def create_user
    params = @user_options.except(:profile)
    user   = User.by_email(params[:email]).first

    user || User.create(params)
  end

  def create_profile(profile)
    @profile = @user.create_profile(
      profile.merge(email: @user.email).except(:address)
    )

    if @profile.valid?
      if profile[:address].present?
        @profile.address_id = Address.create(profile[:address]).id

        @profile.save!
      end
    end
  end
end
