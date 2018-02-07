# From http://stackoverflow.com/questions/449271/how-to-round-a-time-down-to-the-nearest-15-minutes-in-ruby

class Time
  # Patch the Time class to give us a random date within a year range
  # @TODO: Would like to move this to a utils place at some stage
  # http://jroller.com/obie/entry/random_times_for_rails
  def self.random(params={})
    years_back = params[:year_range] || 5
    year = (rand * (years_back)).ceil + (Time.now.year - years_back)
    month = (rand * 12).ceil
    day = (rand * 31).ceil
    series = [date = Time.local(year, month, day)]
    if params[:series]
      params[:series].each do |some_time_after|
        series << series.last + (rand * some_time_after).ceil
      end
      return series
    end
    date
  end

  # Time#round already exists with different meaning in Ruby 1.9
  def round_off(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end

  def hours_since(other_date)
    ((self - other_date) / 60 / 60).to_i
  end

  def minutes_since(other_date)
    ((self - other_date) / 60).to_i
  end

  def self.str_to_time str
    begin
      parse str
    rescue
      nil
    end
  end

  def self.half_year
    now.beginning_of_year + 6.months + 15.day
  end
end
