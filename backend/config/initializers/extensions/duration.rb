class Duration
  def hours_rounded(round_to_minute=15)
    total_minutes = self.total_minutes

    rounded_hours = ((total_minutes.to_f / round_to_minute).round * round_to_minute) / 60.0
  end
end
