class Ability
  include CanCan::Ability

  ALL_RESOURCES = [
    Address, Location, Log, Notification,
    NotificationMetadata, Profile, User
  ]

  def initialize(user)
    user ||= User.new

    can :change_password, User

    case user.role_classification
      when :superuser
        define_superuser_access
      when :client
        define_client_access
      when :unknown
        cannot :manage, :all
    end

    can :exists, User
  end

  def define_superuser_access()
    define_web_access
  end

  def define_client_access()
    define_web_access
  end

  def define_web_access()
    no_access = [
      Notification,
    ]

    manage(ALL_RESOURCES - no_access)
  end

  def manage(resources)
    resources.each { |resource| can :manage, resource }
  end
end
