class Location < ActiveRecord::Base
  DEFAULT_TIMEZONE = 'Australia/Melbourne'
  # @TODO: Remove this once migration to workplace having name is complete
  attr_accessor :name

  # Relationships
  has_many :workplaces
  belongs_to :address

  # Pass-through relationships
  has_many :shifts, through: :workplaces
  has_many :organisations, through: :workplaces

  # Validations
  validates :latitude, presence: true
  validates :longitude, presence: true

  before_save :ensure_timezone

  reverse_geocoded_by :latitude, :longitude

  scope :nearby, -> (coordinates, distance) { near(coordinates, distance, units: :km, order: false) }
  scope :for_user, ->(user) {
    case user.role_classification
      when :superuser
        all
      when :client
        joins(:workplaces)
          .where(workplaces: { organisation_id: user.organisation_ids })
      else
        none
    end
  }

  def name
    self[:name] || @name
  end

  def name=(name)
    @name = name
  end

  def timezone
    timezone = self[:timezone]

    obtain_timezone! if timezone == nil

    self[:timezone]
  end

  def nearby_locations(distance)
    Location.nearby([latitude, longitude], distance)
  end

  private

  def obtain_timezone!
    self[:timezone] = determine_timezone || DEFAULT_TIMEZONE
    save
  end

  def determine_timezone
    begin
      Timezone::Zone.new(latlon: [latitude, longitude]).zone
    rescue Exception => e
      # TODO: Handle this exception. For now, if getting the timezone fails,
      nil
    end
  end

  def ensure_timezone
    if new_record? || coordinates_changed?
      self[:timezone] = determine_timezone
    end
    if timezone_changed?
      shifts.upcoming.find_each do |shift|
        shift.update_timezone timezone
      end
    end
  end

  def coordinates_changed?
    latitude_changed? && longitude_changed?
  end
end
