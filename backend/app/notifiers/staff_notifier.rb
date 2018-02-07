class StaffNotifier
  def self.send_password_reset_to_staff_notification(staff_member)
    recipient_user = staff_member.user

    subject   = 'Password Reset'
    message   = 'Admin has reset your password to your mobile number.'
    options   = { data: { notification_type: 'password_reset' } }

    send_notification(recipient_user, subject, message, options)
  end

  def self.send_notification(recipient_user, subject, message, options={})
    if Rails.application.config.send_notifications
      NotificationSender.send([recipient_user], subject, message, options)
    end
  end
end
