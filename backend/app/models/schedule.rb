class Schedule < ApplicationRecord
  belongs_to :device

  scope :repeating, -> { where repeat: true }
  scope :for_now, -> {
    where(hour: Time.now.hour, minute: Time.now.min)
  }

  def execute
    if repeat
      now = Time.now
      day = now.wday

      run_today = repeat_days.find {|repeat_day| repeat_day['day'] == day && repeat_day['run'] }

      process_action if run_today
    else
      process_action
      destroy
    end
  end

  def process_action
    case action
      when 'turn_on'  then device.request_turn_on
      when 'turn_off' then device.request_turn_on
      when 'restart'  then device.restart
      else nil
    end
  end
end
