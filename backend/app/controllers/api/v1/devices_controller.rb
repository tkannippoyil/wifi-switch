module Api
  module V1
    class DevicesController < ApplicationController
      skip_before_action :authenticate_user!
      skip_before_action :authenticate_user_from_token!
      respond_to :json

      def index
        render json: WattBox.all, status: :ok
      end

      def update
        @device = Device.find_or_create_by(address: params[:id])
        @device.update name: params[:name]
        render json: @device, status: :ok
      end

      def status
        @device = Device.find_or_create_by(address: params[:id])
        @device.check_connectivity!
        render json: @device, status: :ok
      end

      def turn_on
        # @device = Device.find_or_create_by(address: params[:id])
        # @device.request_turn_on
        # render json: @device, status: :ok
        render json: WattBox.new(params[:id]).turn_on, status: :ok
      end

      def turn_off
        # @device = Device.find_or_create_by(address: params[:id])
        # @device.request_turn_off
        # render json: @device, status: :ok
        render json: WattBox.new(params[:id]).turn_off, status: :ok
      end

      def restart
        # @device = Device.find_or_create_by(address: params[:id])
        # @device.restart
        # render json: @device, status: :ok
        render json: WattBox.new(params[:id]).restart, status: :ok
      end

      def turn_on_all
        Device.turn_on_all
        render json: Device.all, status: :ok
      end

      def turn_off_all
        Device.turn_off_all
        render json: Device.all, status: :ok
      end

      def toggle_all
        Device.toggle_all
        render json: Device.all, status: :ok
      end
    end
  end
end
