module Api
  module V1
    class NotificationsController < ApplicationController
      authorize_resource
      respond_to :json

      def index
        @notifications = Notification.includes(:notification_metadata)
                           .for_user(current_user)
                           .references(:notification_metadata)
                           .order(id: :desc)

        params[:per_page] ||= 30
        render json: paginate(@notifications), status: :ok
      end
    end
  end
end
