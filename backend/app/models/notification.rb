class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification_metadata

  scope :for_user, ->(user) {
    case user.role_classification
      when :supervisor, :worker
        where user_id: user.id
      else
        none
    end
  }
end
