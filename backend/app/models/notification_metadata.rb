class NotificationMetadata < ActiveRecord::Base
  has_many :notifications, dependent: :destroy
end
