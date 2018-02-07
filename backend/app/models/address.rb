class Address < ActiveRecord::Base
  def display
    "#{street_address}, #{suburb}, #{state} #{postcode}, #{country}"
  end
end
