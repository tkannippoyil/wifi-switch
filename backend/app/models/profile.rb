class Profile < ActiveRecord::Base
  # Relationships
  belongs_to :address
  belongs_to :user

  has_one :global_staff_member_profile, dependent: :destroy
  has_many :staff_availabilities,     dependent: :destroy

  has_attached_file :avatar,
                    storage:     :s3,
                    s3_protocol:    :https,
                    s3_host_name:   's3-ap-southeast-2.amazonaws.com',
                    bucket:      ENV['S3_BUCKET_NAME'],
                    styles:      { profile: '150x150>', small: '40x40', tiny: '20x20' },
                    default_url: 'https://s3-ap-southeast-2.amazonaws.com/prompa/static/placeholder/avatar-default-300x300.png'

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  # Validations
  validates :user_id, presence: true, uniqueness: true
  validates :gender, inclusion: %w(Male Female Other Unspecified)

  validate :email_matches_user_email

  validates_associated :user

  after_initialize :set_defaults

  scope :for_user, ->(user) {
    case user.role_classification
      when :superuser
        all
      when :client
        joins(user: [ :staff_member ])
        .where(
          'staff_members.organisation_id IN (:organisation_ids) or profiles.user_id = :user_id',
          organisation_ids: user.organisation_ids, user_id: user.id
        )
      when :worker, :supervisor
        where(user_id: user.id)
      else
        none
    end
  }

  def set_defaults
    self.gender = 'Unspecified' unless gender.present?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def preferred_name
    preferred_name = read_attribute(:preferred_name)
    preferred_name.nil? ? read_attribute(:first_name) : preferred_name
  end

  def self.create_for_user(user, attrs)
    Profile.create({ user_id: user.id }.merge(attrs))
  end

  def add_global_staff_member_profile(attrs={})
    GlobalStaffMemberProfile.create({profile_id: self.id}.merge(attrs))
  end

  def contact_phone
    phone_number
  end

  def create_default_availabilities
    get_default_avalabilities.map &:save
  end

  def get_default_avalabilities
    staff_availability = []
    7.times do |day|
      new_entry = staff_availabilities.new(day_id: day)
      new_entry.start_time = StaffAvailability::DAY_START
      new_entry.end_time   = StaffAvailability::DAY_END

      staff_availability << new_entry
    end
    staff_availability
  end

  def availability
    create_default_availabilities unless staff_availabilities.present?
    AvailabilityJsonParser.new(self).read_availability
  end

  private

  def email_matches_user_email
    errors.add(:email, I18n.translate('prompa.errors.profile_email_mismatch')) unless email == user.email
  end
end
