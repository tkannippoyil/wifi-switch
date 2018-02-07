class ScheduleSerializer < ApplicationSerializer
  attributes :id, :name, :repeat, :hour, :minute, :repeat_days
  has_one :device
end
