class UserSerializer < ApplicationSerializer
  V1 = [ :email, :role_classification, :is_new ]
  V2 = [ :email, :role_classification, :created_at ]

  NOT_REQUIRED_FOR_API = {
    mobile_roster_supervisor: V1,
    mobile_roster_staff:      V1,
    mobile_ts_entry:          V1,
    limited_timesheet_entry:  V1,
    job_candidates_admin:     V2,
    limited_staff_members:    V2,
    with_tags_staff_members:  V2,
    requirement_candidates:   V2,
  }

  attributes :id, :email, :created_at, :role_classification, :is_new

  has_one :profile

  delegate :current_user, to: :scope
end
