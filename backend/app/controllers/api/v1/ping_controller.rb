module Api
  module V1
    class PingController < ApplicationController
      skip_before_action :authenticate_user!
      skip_before_action :authenticate_user_from_token!
      respond_to :json

      def index
        render json: { server_available: true }, status: :ok
      end
    end
  end
end
