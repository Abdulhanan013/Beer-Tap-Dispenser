# app/controllers/dispensers_controller.rb

class DispensersController < ApplicationController

  def index
    @dispensers = Dispenser.all
    render json: @dispensers
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

  private

  def dispenser_params
    params.require(:dispenser).permit(:flow_volume, :name)
  end
end
