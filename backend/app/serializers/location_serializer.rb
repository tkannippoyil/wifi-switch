class LocationSerializer < ApplicationSerializer
  attributes :id, :name, :latitude, :longitude

  has_one :address
end
