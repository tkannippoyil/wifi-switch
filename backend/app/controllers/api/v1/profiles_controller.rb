module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user!
      authorize_resource
      before_action :extract_date_of_birth, only: :update
      before_action :extract_avatar_image, only: :update
      respond_to :json

      def show
        if params[:user_id]
          @profile = User.for_user(current_user).find(params[:user_id]).profile
        else
          @profile = Profile.for_user(current_user).find(params[:id])
        end
        render json: @profile
      end

      def update
        @user    = User.for_user(current_user).find(params[:user_id])
        @profile = @user.profile

        @profile.assign_attributes(profile_params)

        if @profile.valid?
          if params[:profile][:address].present?
            if @profile.address.nil?
              @profile.address_id = Address.create(address_params).id
            else
              @profile.address.update_attributes(address_params)
            end
          end
        end

        # @TODO: Move profile update into its own action
        # Update user email to ensure change persists
        if @profile.email_changed?
          @profile.user.email = @profile.email
          @profile.user.save
        end

        @profile.save

        if @profile.errors.empty?
          render json: @profile, status: :ok
        else
          render json: @profile.errors, status: :not_acceptable
        end
      end

      private

      def extract_date_of_birth
        if params[:profile][:date_of_birth].present?
          params[:profile][:date_of_birth] = Date.parse(params[:profile][:date_of_birth])
        end
      end

      def extract_avatar_image
        if params[:profile][:avatar].present?
          has_relevant_data = [ :filename, :content, :content_type ].all?{|key|
            params[:profile][:avatar][key].present?
          }

          # @TODO: Should be giving back a bad request here
          # if there's a fuck up or data is missing
          if has_relevant_data
            image_data = params[:profile][:avatar]

            @tempfile = Tempfile.new('item_image')
            @tempfile.binmode
            @tempfile.write Base64.decode64(image_data[:content])
            @tempfile.rewind

            uploaded_file = ActionDispatch::Http::UploadedFile.new(
              tempfile: @tempfile,
              filename: image_data[:filename]
            )

            uploaded_file.content_type = image_data[:content_type]

            # Replace avatar with uploaded file
            params[:profile][:avatar] = uploaded_file
          else
            params[:profile].delete :avatar
          end
        end
      end

      def profile_params
        params.require(:profile).permit(
          :user_id,
          :salutation,
          :first_name,
          :preferred_name,
          :last_name,
          :date_of_birth,
          :email,
          :phone_number,
          :last_active,
          :address_id,
          :gender,
          :avatar,
          :onboarded
        )
      end

      def address_params
        params[:profile].require(:address).permit(
          :street_address,
          :country,
          :postcode,
          :state,
          :suburb
        )
      end
    end
  end
end
