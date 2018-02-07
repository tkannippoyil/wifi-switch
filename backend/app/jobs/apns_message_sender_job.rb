class ApnsMessageSenderJob < ActiveJob::Base
  queue_as :apns_message_queue

  def perform(recipient_ids, subject, message, notification_metadata_id)
    recipient_registration_ids = MobileDevice.ios.where(
      user_id: recipient_ids
    ).pluck(:vendor_registration_id)

    notification_metadata = NotificationMetadata.find(notification_metadata_id)

    NotificationUtils.send_apns_notification(
      recipient_registration_ids, subject, message, notification_metadata
    )
  end
end
