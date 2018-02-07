class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :set_mailer_host

  before_action :authenticate_user_from_token!

  before_action :authenticate_user!

  serialization_scope :view_context

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from CanCan::AccessDenied,         with: :forbidden

  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end

  def forbidden
    render json: { error: 'Access Denied' }, status: :forbidden
  end

  def unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
  # ---

  def log_action(category, message, data={})
    options = {
      category:   category,
      message:    message,
      controller: controller_name,
      action:     action_name,
      data:       data,
      user_id:    current_user.id
    }

    ActionLoggerJob.perform_later options
  end

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  private

  def authenticate_user_from_token!
    authentication_token = params[:authentication_token]

    unless authentication_token.present?
      unauthorized
      return
    end

    user = User.find_by_authentication_token(authentication_token.to_s)

    if user
      user.can_login? ? sign_in(user, store: false) : unauthorized
    else
      render json: { error: 'Token Not Found' }, status: :not_found
    end
  end

  def paginate(objects)
    page     = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].present? ? params[:per_page].to_i : 15
    offset   = (page - 1) * per_page

    objects.offset(offset).limit(per_page)
  end

  def get_role()
    case current_user.try :role_classification
      when :superuser
        :admin
      else
        :unknown
    end
  end

  def api_name(content, context, role)
    names = [ context, content ]
    names << get_role if role
    names.compact.join('_').to_sym
  end

  def get_context(content, role=true, context='mobile')
    { api: api_name(content, context, role) }
  end
end
