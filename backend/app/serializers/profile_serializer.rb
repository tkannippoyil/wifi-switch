class ProfileSerializer < ApplicationSerializer
  V1 = [
    :user_id, :salutation, :date_of_birth, :gender, :email, :phone_number,
    :home_phone, :mobile_phone, :phone_after_hours, :phone_business_hours,
    :last_active, :onboarded, :address, :global_staff_member_profile
  ]
  V2 = [
    :user_id, :salutation, :first_name, :preferred_name, :last_name,:date_of_birth,
    :gender, :email, :phone_number, :home_phone, :mobile_phone, :phone_after_hours,
    :phone_business_hours, :last_active, :onboarded, :address,
    :global_staff_member_profile, :contact_phone
  ]
  NOT_REQUIRED_FOR_API = {
    mobile_roster_supervisor: V1,
    mobile_roster_staff:      V1,
    limited_timesheet_entry:  V1,
    mobile_ts_entry:          V1,
    job_candidates_admin:     V2,
    limited_staff_members:    V1 + [:avatar],
    with_tags_staff_members:  V1,
    requirement_candidates:   V1,
    allocations:              V1 + [:email],
    live_allocations:         V1 + [:email],
  }

  attributes  :id,
              :user_id,
              :salutation,
              :first_name,
              :preferred_name,
              :last_name,
              :name,
              :date_of_birth,
              :gender,

              :email,
              :phone_number,
              :home_phone,
              :mobile_phone,
              :contact_phone,
              :phone_after_hours,
              :phone_business_hours,
              :last_active,
              :avatar,
              :onboarded

  has_one :address
  has_one :global_staff_member_profile

  def name
    "#{first_name} #{last_name}"
  end

  def avatar
    {
      profile: object.avatar.url(:profile),
      small:   object.avatar.url(:small),
      tiny:    object.avatar.url(:tiny)
    }
  end

  def phone_business_hours
    object.phone_number
  end

  def phone_after_hours
    object.phone_number
  end

  def mobile_phone
    object.phone_number
  end

  def home_phone
    object.phone_number
  end
end
