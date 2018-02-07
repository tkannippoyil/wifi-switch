class AddressSerializer < ApplicationSerializer
  attributes :id,
             :street_address,
             :country,
             :postcode,
             :state,
             :suburb,
             :display
  def display
    object.display
  end
end
