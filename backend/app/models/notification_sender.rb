class NotificationSender
  include NotificationUtils

  def self.send(recipients, subject, message, options={})
    notification_metadata = NotificationMetadata.create(
      subject: subject,
      message: message,
      data:    options[:data] || {}
    )

    recipients.each do |recipient|
      Notification.create(
        notification_metadata_id: notification_metadata.id,
        user_id:                  recipient.id
      )
    end

    # @TODO: Deal with user prefs for notifications
    send_mobile_device_notification(recipients, subject, message, notification_metadata)
  end

  def self.send_mobile_device_notification(recipient_users, subject, message, notification_metadata)
    # Determine which recipients were not found
    users_with_devices    = recipient_users.select{|user| !user.mobile_devices.empty? }
    ids_of_users_with_devices = users_with_devices.map &:id
    users_without_devices = recipient_users - users_with_devices

    # @TODO: Add in response which users do not have devices
    platform_grouped_devices = users_with_devices.reduce({}) {|result, user|
      user.mobile_devices.each do |device|
        result[device.platform] ||= []
        result[device.platform] << device
      end
      result
    }

    platform_grouped_devices.each do |platform, platform_devices|
      if platform == 'iOS'
        ApnsMessageSenderJob.perform_later ids_of_users_with_devices, subject, message, notification_metadata.id
      elsif platform == 'Android'
        GcmMessageSenderJob.perform_later ids_of_users_with_devices, subject, message, notification_metadata.id
      end
    end
  end
end
