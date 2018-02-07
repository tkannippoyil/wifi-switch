class AuthUserSerializer < ApplicationSerializer
  attributes :id, :authentication_token, :role_classification, :onboarded, :global_staff_member_profile_id

  def onboarded
    object.profile.onboarded
  end

  def global_staff_member_profile_id
    object.profile.try(:global_staff_member_profile).try(:id)
  end

  def attributes
    # @TODO: Find a cleaner way to serialize a user's affiliation
    # with entities in the system that incorporates multiple affiliations
    # (e.g. with an organisation, if required)
    hash = super

    resources = object.resources_for_role_classification

    if resources.present?
      hash['affiliation'] = {}

      if resources.is_a? Personnel
        hash['affiliation']['organisation'] = {
          id:             resources.organisation.id,
          name:           resources.organisation.name,
          provides_staff: resources.organisation.provides_staff,
          onboarded:      resources.organisation.onboarded,
          requests_staff: resources.organisation.requests_staff,
          has_agencies:   resources.organisation.has_agencies?,
          classification: resources.organisation.classification,
          paid:           resources.organisation.paid?,
        }
      end
    end

    hash
  end
end
