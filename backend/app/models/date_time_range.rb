class DateTimeRange
  attr_accessor :start_time, :end_time

  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time   = end_time
  end

  def to_date_range(timezone=nil)
    if timezone.present?
      DateRange.new(
        @start_time.in_time_zone(timezone).to_date,
        @end_time.in_time_zone(timezone).to_date
      )
    else
      DateRange.new(
        @start_time.to_date,
        @end_time.to_date
      )
    end
  end
end
