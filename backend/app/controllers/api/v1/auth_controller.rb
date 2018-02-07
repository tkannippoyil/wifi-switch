module Api
  module V1
    # Our custom override of Devise's SessionsController. For quick comparison, see:
    # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/sessions_controller.rb
    class AuthController < Devise::SessionsController
      skip_before_action :require_no_authentication, only: :create
      skip_before_action :verify_signed_out_user, only: :destroy
      before_action :authenticate_user_from_token!, only: :destroy
      respond_to :json

      include Devise::Controllers::Helpers

      def create
        resource = warden.authenticate!(scope: resource_name, recall: 'sessions#failure')
        if resource.can_login? and resource.organisation_is_active?
          return sign_in_and_redirect(resource_name, resource)
        else
          render json: { error: 'User Not Active' }, status: :not_acceptable
        end
      end

      def destroy
        sign_out_and_redirect(resource_name)
      end

    private
      def sign_in_and_redirect(resource_or_scope, resource=nil)
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        resource ||= resource_or_scope
        sign_in(scope, resource) unless warden.user(scope) == resource
        resource.ensure_authentication_token!
        resource.save!

        user = AuthUserSerializer.new(
          resource,
          scope: serialization_scope
        ).as_json

        render json: { success: true, user: user }
      end

      def authenticate_user_from_token!
        authentication_token = params[:authentication_token].presence
        user = authentication_token && User.find_by_authentication_token(authentication_token.to_s)

        if user
          sign_in user, store: false
        else
          render json: { error: 'Token Not Found' }, status: :not_found
        end
      end

      def sign_out_and_redirect(resource_or_scope)
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        current_user.clear_authentication_token!

        if Devise.sign_out_all_scopes
          sign_out_all_scopes
        else
          sign_out(scope)
        end
        render json: { status: :signed_out }
      end
    end
  end
end
