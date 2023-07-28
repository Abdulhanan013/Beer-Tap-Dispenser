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
    dispenser.update(status: false)
    calculate_event_details(event)
  end

  private

  def calculate_event_details(event)
    time_diff_seconds = (event.end_time - event.start_time).to_i
    liters = dispenser.flow_volume * time_diff_seconds
    price = calculate_price(liters)
    event.update(liters: liters, price: price)
  end

  def calculate_price(liters)
    price = liters * dispenser.price_per_liter
    price
  end
end
