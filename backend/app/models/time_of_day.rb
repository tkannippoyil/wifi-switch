class TimeOfDay
  include Comparable

  attr_reader :hour, :minute, :seconds_in_day, :locale

  def initialize(hour, minute=0, locale='Australia/Melbourne')
    @hour   = hour.to_i
    @minute = minute.to_i
    @locale = locale

    raise ArgumentError, 'hour must be between 0 and 23' unless (0..23).include?(@hour)
    raise ArgumentError, 'minute must be between 0 and 59' unless (0..59).include?(@minute)
    raise ArgumentError, 'invalid locale provided' unless TZInfo::Timezone.all_country_zone_identifiers.include?(@locale)

    @seconds_in_day = @hour * 60 * 60 + @minute * 60
  end

  def <=>(other)
    @seconds_in_day <=> other.seconds_in_day
  end

  # Converts TimeOfDay to Time format using the year, month and day from the provided Date
  def to_time(date)
    ActiveSupport::TimeZone.new(@locale).local(date.year, date.month, date.day, @hour, @minute, 0)
  end

  def to_s()
    to_time(Date.today).to_s
  end
end
