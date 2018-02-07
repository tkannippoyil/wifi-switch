class UserOnboardingMailer < ActionMailer::Base
  default from: 'App <jobs@test.net>'
  layout 'mailer'

  def welcome(user, options={})
    @user_profile = user.profile

    mail to: user.email, subject: 'Invitation to Join'
  end
end
