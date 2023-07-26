class DispenserService
  attr_reader :dispenser, :current_user

  def initialize(dispenser, current_user)
    @dispenser = dispenser
    @current_user = current_user
  end

  def mark_tap_open
    dispenser.dispenser_events.create(event_type: 'open', start_time: Time.now, user_id: current_user.id)
    dispenser.update(status: true)
  end

  def mark_tap_close
    event = dispenser.dispenser_events.last
    return if event.nil? || event.end_time.present?

    event.update(event_type: 'close', end_time: Time.now)
    calculate_total_price(event)
    dispenser.update(status: false)
  end

  private

  def calculate_total_price(event)
    time_diff_seconds = (event.end_time - event.start_time).to_i
    total_liters = dispenser.flow_volume * time_diff_seconds
    total_price = calculate_price(total_liters)
    event.update(total_liters: total_liters, total_price: total_price)
  end

  def calculate_price(total_liters)
    # Implement the logic to calculate the price based on the total_liters.
    # You can set the pricing rules here.
    # For simplicity, let's assume $1 per liter.
    total_liters
  end
end
