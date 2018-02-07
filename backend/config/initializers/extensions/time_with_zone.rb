module ActiveSupport
  class TimeWithZone
    def timezone_offset
      offset = utc_offset.to_f / 3600.0

      # Grab the sign
      sign = if offset > 0
        '+'
      elsif offset < 0
        '-'
      else
        ''
      end

      # Grab hours and pad if needed
      hours = offset.abs.floor.to_s.rjust(2, '0')

      # Either 0 or 30 minutes
      if offset % 1 == 0
        minutes = '00'
      else
        minutes = '30'
      end

      # Join sign and time
      "#{sign}#{hours}:#{minutes}"
    end
  end
end
