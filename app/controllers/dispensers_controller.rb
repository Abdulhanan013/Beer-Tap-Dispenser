# app/controllers/dispensers_controller.rb

class DispensersController < ApplicationController

  def index
    @dispensers = Dispenser.all
    render json: @dispensers
  end

  def show
    @dispenser = Dispenser.find(params[:id])
    render json: {
      id: @dispenser.id,
      name: @dispenser.name,
      flow_volume: @dispenser.flow_volume,
      status: @dispenser.status,
      total_usage_count: @dispenser.total_usage_count,
      total_usage_time: @dispenser.total_usage_time,
      total_earnings: @dispenser.total_earnings
    }
  end

  def create
    if @current_user.admin?
      @dispenser = Dispenser.new(dispenser_params)
      @dispenser.user_id = @current_user.id

      if @dispenser.save
        render json: @dispenser, status: :created
      else
        render json: @dispenser.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Only admin users can create dispensers.' }, status: :forbidden
    end
  end


  def update
    @dispenser = Dispenser.find(params[:id])
    service = DispenserService.new(@dispenser, @current_user)

    if params[:status] == 'open'
      service.mark_tap_open
      render json: { message: 'Dispenser tap opened successfully.' }
    elsif params[:status] == 'close'
      service.mark_tap_close
      render json: { message: 'Dispenser tap closed successfully.' }
    else
      render json: { error: 'Invalid status provided.' }, status: :unprocessable_entity
    end
  end

  def destroy
    @dispenser = Dispenser.find(params[:id])

    if @current_user.admin?
      @dispenser.destroy
      render json: { message: 'Dispenser deleted successfully.' }, status: :ok
    else
      render json: { error: 'Only admin users can delete dispensers.' }, status: :forbidden
    end
  end

  def total_statistics
    if @current_user.promoter?
      total_earnings = Dispenser.total_earnings_for_all_dispensers
      total_usage_time = Dispenser.total_usage_time_for_all_dispensers

      render json: {
        total_earnings: total_earnings,
        total_usage_time: total_usage_time
      }
    else
      render json: { error: 'Only Promoters can see stats.' }, status: :forbidden
    end
  end

  private

  def dispenser_params
    params.require(:dispenser).permit(:flow_volume, :name, :price_per_liter)
  end
end
