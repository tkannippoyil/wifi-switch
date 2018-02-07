module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, except: :exists
      skip_before_action :authenticate_user_from_token!, only: :exists
      authorize_resource
      before_action :set_user, only: :show
      respond_to :json

      def index
        @users = User.for_user(current_user).all

        @users = @users.where(email: params[:email]) if params[:email]

        render json: paginate(@users), status: :ok
      end

      def show
        render json: @user, status: :ok
      end

      def exists
        if params[:email].present?
          @user = User.by_email(params[:email]).first


          exists = case @user.try :role_classification
                     when :client
                       check_for_deleted_employee
                     when :worker, :supervisor, :superuser
                       check_in_organisation
                     when nil
                       false
                     else
                       true
                   end

          render json: { exists: exists, status: :ok }
        else
          render json: { status: :bad_request, message: 'Did not provide an email address' }
        end
      end

      def check_in_organisation
        if params[:organisation_id].present?
          @user.staff_memberships.pluck(:organisation_id).include?  params[:organisation_id].to_i
        else
          true
        end
      end

      def check_for_deleted_employee
        if params[:organisation_id].present?
          @user.employments.for_organisation(params[:organisation_id]).inactive.empty?
        else
          true
        end
      end

      def change_password
        @user = current_user
        @user.update_attributes(user_params)

        if @user.errors.empty?
          render json: @user, status: 202
        else
          render json: @user.errors, status: :not_acceptable
        end
      end

      private

      def set_user
        @user = User.for_user(current_user).find(params[:id] || current_user.id)
      end

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :superuser)
      end

      def change_password_params
        params.require(:user).permit(:password, :password_confirmation)
      end
    end
  end
end
