class User < ActiveRecord::Base
  before_save :ensure_authentication_token!

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Relationships
  has_one  :profile,                      dependent: :destroy
  has_one  :staff_member,                 dependent: :destroy
  has_one  :personnel,                 dependent: :destroy
  has_many :mobile_devices,               dependent: :destroy
  has_many :employments,                  dependent: :destroy, class_name: 'Personnel',   foreign_key: 'user_id'
  has_many :staff_memberships,            dependent: :destroy, class_name: 'StaffMember', foreign_key: 'user_id'
  has_many :circle_memberships,           dependent: :destroy
  has_many :timesheet_reviews,            dependent: :destroy, foreign_key: 'reviewer_id'
  has_many :geofence_transitions,         dependent: :destroy

  # TODO: Revise author_id relation
  has_many :rosters,                     class_name: 'Roster',        foreign_key: 'author_id'
  has_many :logs

  # Pass-through relationships
  has_many :organisations,     through: :employments
  has_many :timesheet_entries, through: :staff_memberships
  has_many :circles,           through: :circle_memberships

  # Method delegations
  delegate :name, to: :profile
  delegate :availability, to: :profile

  # Validations
  validates :email, presence: true
  validates :superuser, inclusion: [true, false]   # See http://tinyurl.com/2wdscg for why this isn't 'validates_presence_of :superuser'

  scope :by_email, -> (email) { where('users.email ILIKE ?', email) }

  scope :to_message, ->(user) {
    case user.role_classification
      when :superuser
        all
      when :client
        joins(:staff_memberships)
          .where(staff_members: { organisation_id: user.organisation_ids })
      else
        none
    end
  }

  scope :for_user, ->(user) {
    case user.role_classification
      when :superuser
        all
      when :client
        joins(:staff_memberships)
          .where(staff_members: { organisation_id: user.organisation_ids })
      when :worker, :supervisor
        where id: user.id
      else
        none
    end
  }

  scope :by_email, -> (email) { where('users.email ILIKE ?', email) }

  def ensure_authentication_token!
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def clear_authentication_token!
    self.authentication_token = nil
    save!
  end

  # @TODO: This is only in place for the trial. It breaks the fundamental concept that users can have multiple roles within multiple agencies/companies.
  def has_role?(role)
    if role.is_a? Array
      role.include? role_classification
    else
      role_classification == role
    end
  end

  # Gives a classification for what type of user this is. For the trial, each user has only one 'role' within the system.
  # If they need another role, they need to create another user account.
  # @TODO: This is only in place for the trial. It breaks the fundamental concept that users can have multiple roles within multiple agencies/companies.
  def role_classification
    if superuser?
      :superuser
    elsif staff_memberships.present?
      staff_membership = staff_memberships.first

      if staff_membership.supervisor?
        :supervisor
      else
        # @TODO: Rename worker to worker
        :worker
      end
    elsif employments.present?
      :client
    else
      :unknown
    end
  end

  # Returns the main resources for a given role classification. For instance, a HR Admin's main resource is their AgencyPersonnel, whereas
  # a client's main resource is their CompanyPersonnel (and perhaps their RecruitmentContracts).
  # @TODO: This is only in place for the trial. Eventually, users won't be shoe-horned into one role like this.
  def resources_for_role_classification
    case role_classification
      when :superuser                   then nil
      when :human_resources_admin       then employments.first
      when :supervisor
        if employments.present?
          employments.first
        elsif staff_memberships.present?
          staff_memberships.first
        else
          nil
        end
      when :worker                      then staff_memberships.first
      when :client                      then employments.first
      when :unknown                     then nil
    end
  end

  def superuser?
    superuser == true
  end

  # Details:
  # :salutation, :first_name, :last_name, :date_of_birth, :phone_number, :avoid_for, :characteristics,
  # :street_address, :suburb, :state, :postcode, :country
  def add_profile(details)
    # @TODO: Having all attributes explicity listed here is stinky as fuck
    profile = Profile.create!(
      user_id:       id,
      email:         self.email,
      salutation:    details[:salutation],
      first_name:    details[:first_name],
      last_name:     details[:last_name],
      gender:        details[:gender],
      date_of_birth: details[:date_of_birth],
      phone_number:  details[:phone_number],
      avatar:        details[:avatar]
    )

    if details[:address].present?
      profile.address_id = Address.where(
        street_address: details[:address][:street_address],
        suburb:         details[:address][:suburb],
        state:          details[:address][:state],
        postcode:       details[:address][:postcode],
        country:        details[:address][:country]
      ).create.id

      profile.save
    end
  end

  def is_new
    created_at > 3.months.ago
  end

  def can_login?
    case role_classification
      when :superuser
        true
      when :client
        employments.active.present?
      when :worker, :supervisor
        staff_memberships.active.present?
      else
        false
    end
  end

  def organisation_is_active?
    case role_classification
      when :superuser
        true
      when :client
        organisations.active.present?
      when :worker, :supervisor
        true
      else
        false
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
