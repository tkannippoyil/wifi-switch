class TimeBracket
  attr_accessor :start_time, :end_time, :locale

  def initialize(start_time, end_time)
    raise ArgumentError, 'start_time can not be nil' unless start_time
    raise ArgumentError, 'end_time can not be nil' unless end_time
    raise ArgumentError, 'end_time must be after start_time' unless start_time < end_time
    raise ArgumentError, 'start_time and end_time locales do not match' unless start_time.locale == end_time.locale

    @start_time = start_time
    @end_time = end_time

    @locale = start_time.locale
  end

  def start_time_as_time(time=Time.now)
    @start_time.to_time(time)
  end

  def end_time_as_time(time=Time.now)
    @end_time.to_time(time)
  end

  # Compares the provided start and end times to determine if they fall within the TimeBracket
  def include?(shift_start_time, shift_end_time)
    shift_start_time < shift_end_time &&
    include_start_time?(shift_start_time) &&
    include_end_time?(shift_end_time)
  end

  def include_start_time?(shift_start_time)
    start_time_as_time  = @start_time.to_time(shift_start_time)
    end_time_as_time    = @end_time.to_time(shift_start_time).utc

    if end_time_as_time >= start_time_as_time
      # If the shift_start_time falls within the TimeBracket
      shift_start_time.utc >= start_time_as_time && shift_start_time <= end_time_as_time
    else
      start_of_day_time   = TimeOfDay.new(0,0).to_time(shift_start_time).utc
      end_of_day_time     = TimeOfDay.new(23,59).to_time(shift_start_time).utc

      # If the shift_start_time falls within shift time which runs over two separate days
      (shift_start_time.utc >= start_time_as_time && shift_start_time.utc <= end_of_day_time) ||
      (shift_start_time.utc >= start_of_day_time && shift_start_time.utc <= end_time_as_time)
    end
  end

  def include_end_time?(shift_end_time)
    start_time_as_time  = @start_time.to_time(shift_end_time).utc
    end_time_as_time    = @end_time.to_time(shift_end_time).utc

    if end_time_as_time >= start_time_as_time
      # If the shift_end_time falls within the TimeBracket
      shift_end_time.utc >= start_time_as_time && shift_end_time <= end_time_as_time
    else
      start_of_day_time   = TimeOfDay.new(0,0).to_time(shift_end_time).utc
      end_of_day_time     = TimeOfDay.new(23,59).to_time(shift_end_time).utc

      # If the shift_end_time falls within shift time which runs over two separate days
      (shift_end_time.utc >= start_time_as_time && shift_end_time.utc <= end_of_day_time) ||
      (shift_end_time.utc >= start_of_day_time && shift_end_time.utc <= end_time_as_time)
    end
  end

  def overlap?(other_time_bracket)
    # If either of the times fall within the TimeBracket then an overlap has occurred
    include_start_time?(other_time_bracket.start_time_as_time) || include_end_time?(other_time_bracket.end_time_as_time)
  end

  def overlaps?(time_brackets)
    # If any of the comparisons are true then it indicates an overlap has occurred
    time_brackets.any?{|other_bracket|
      overlap?(other_bracket)
    }
  end
end
