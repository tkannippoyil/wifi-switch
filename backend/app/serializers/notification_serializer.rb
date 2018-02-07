class NotificationSerializer < ApplicationSerializer
  attributes :id, :user_id, :subject, :message, :data, :created_at

  def subject
    object.notification_metadata.subject
  end

  def message
    object.notification_metadata.message
  end

  def data
    object.notification_metadata.data
  end
end
