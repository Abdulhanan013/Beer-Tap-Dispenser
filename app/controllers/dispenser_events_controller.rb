class DispenserEventsController < ApplicationController
    before_action :authenticate_user
    before_action :set_dispenser
  
    def create
        @dispenser_event = @dispenser.dispenser_events.build(opened_at: Time.now)
    
        if @dispenser_event.save
          render json: @dispenser_event, status: :created
        else
          render json: @dispenser_event.errors, status: :unprocessable_entity
        end
      end
    
      def update
        @dispenser_event = @dispenser.dispenser_events.find(params[:id])
        @dispenser_event.closed_at = Time.now
        @dispenser_event.update(price: calculate_price(@dispenser_event.opened_at, @dispenser_event.closed_at, @dispenser.flow_volume))
    
        if @dispenser_event.save
          render json: @dispenser_event, status: :ok
        else
          render json: @dispenser_event.errors, status: :unprocessable_entity
        end
      end
    private
  
    def set_dispenser
      @dispenser = Dispenser.find(params[:dispenser_id])
    end
  
    def calculate_price(start_time, end_time, flow_volume)
      price_per_liter = 10  
      lit ers_poured = (end_time - start_time) * flow_volume
      price = liters_poured * price_per_liter
      return price
    end
end
