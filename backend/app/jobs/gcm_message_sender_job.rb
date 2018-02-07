class GcmMessageSenderJob < ActiveJob::Base
  queue_as :gcm_message_queue

  def perform(recipient_ids, subject, message, notification_metadata_id)
    # @TODO: Use GCM message sending method here
    # to send a message
    recipient_registration_ids = MobileDevice.android.where(
      user_id: recipient_ids
    ).pluck(:vendor_registration_id)

    notification_metadata = NotificationMetadata.find(notification_metadata_id)
    NotificationUtils.send_gcm_notification(recipient_registration_ids, subject, message, notification_metadata)
  end
end
