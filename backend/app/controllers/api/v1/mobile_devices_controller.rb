module Api
  module V1
    class MobileDevicesController < ApplicationController
      before_action :authenticate_user!
      authorize_resource
      respond_to :json

      def create
        @mobile_device = MobileDevice.find_by(
          vendor_registration_id: params[:mobile_device][:vendor_registration_id]
        )

        if !@mobile_device
          @mobile_device = current_user.mobile_devices.create(mobile_device_params)
        else
          @mobile_device.user = current_user
          @mobile_device.save
        end

        if @mobile_device.errors.empty?
          render json: @mobile_device, status: :created
        else
          render json: @mobile_device.errors, status: :not_acceptable
        end
      end

      def destroy
        @device = current_user.mobile_devices.find(params[:id])
        @device.destroy
        render json: @device, status: :ok
      end

      private

      def mobile_device_params
        params.require(:mobile_device).permit(
          :vendor_registration_id, :platform
        )
      end
    end
  end
end
