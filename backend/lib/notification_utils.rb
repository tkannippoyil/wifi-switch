# Utility module for all notifications, both mobile devices and email
module NotificationUtils
  def self.send_gcm_notification(recipients, subject, message, notification_metadata=nil)
    gcm     = Rpush::Gcm::Notification.new
    gcm.app = Rpush::Gcm::App.find_by_name(RailsApiBase::Application.config.gcm_app_name)

    payload_data = { subject: subject, message: message }

    if notification_metadata.try(:data).present?
      payload_data.merge!(notification_metadata.data)
    end

    gcm.registration_ids  = recipients
    gcm.data              = payload_data
    gcm.content_available = true
    gcm.save!
  end

  def self.send_apns_notification(recipients, subject, message, notification_metadata=nil)
    payload = notification_metadata.try(:data) || {}

    app     = Rpush::Apns::App.find_by_name(IOS_CONFIG['app_name'])

    recipients.map do |recipient_device|
      apns = Rpush::Apns::Notification.new

      apns.app          = app
      apns.device_token = recipient_device
      apns.category     = payload['notification_type']
      apns.alert        = message
      apns.data         = { data: payload }
      apns.save!
    end
  end
end
