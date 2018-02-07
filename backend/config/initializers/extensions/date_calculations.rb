class DateTime
  def hours_since(other_date)
    ((self - other_date) * 24).to_i
  end

  def minutes_since(other_date)
    ((self - other_date) * 24 * 60).to_i
  end
end
