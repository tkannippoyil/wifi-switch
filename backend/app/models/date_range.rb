class DateRange
  attr_accessor :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date   = end_date
  end

  def overlaps_with?(other_date_range)
    (@start_date >= other_date_range.start_date && @start_date <= other_date_range.end_date) || (@end_date >= other_date_range.start_date && @end_date <= other_date_range.end_date)
  end

  def to_json
    {
      start_date: @start_date.strftime('%Y-%m-%d'),
      end_date:   @end_date.strftime('%Y-%m-%d')
    }
  end
end
