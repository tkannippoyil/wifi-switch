module Api
  module V1
    class SchedulesController < ApplicationController
      skip_before_action :authenticate_user!
      skip_before_action :authenticate_user_from_token!
      respond_to :json

      before_action :set_schedule, only: [:show, :edit, :update, :destroy]

      # GET /schedules
      def index
        @schedules = Schedule.all
        render json: @schedules, status: :ok
      end

      # GET /schedules/1
      def show
        render json: @schedule, status: :ok
      end

      # GET /schedules/new
      def new
        @schedule = Schedule.new
        render json: @schedule, status: :ok
      end

      # GET /schedules/1/edit
      def edit
      end

      # POST /schedules
      def create
        @schedule = Schedule.new(schedule_params)

        if @schedule.save
          render json: @schedule, status: :ok
        else
          render json: @schedule, status: :ok
        end
      end

      # PATCH/PUT /schedules/1
      def update
        if @schedule.update(schedule_params)
          render json: @schedule, status: :ok
        else
          render json: @schedule, status: :ok
        end
      end

      # DELETE /schedules/1
      def destroy
        @schedule.destroy
        render json: @schedule, status: :ok
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_schedule
        @schedule = Schedule.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def schedule_params
        params.require(:schedule).permit(:name, :repeat, :hour, :minute, :repeat_days, :device_id)
      end
    end
  end
end
