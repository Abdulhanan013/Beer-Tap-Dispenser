require 'rails_helper'

RSpec.describe DispenserService do
  let(:admin_user) { User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', role: 'admin') }
  let(:attendee_user) { User.create(name: 'Attendee User', email: 'attendee@example.com', password: 'password', role: 'attendee') }
  let(:dispenser) { Dispenser.create(name: 'Dispenser', flow_volume: 20, user_id: admin_user.id, price_per_liter: 3) }

  describe '#mark_tap_open' do
    it 'creates a new dispenser event and updates dispenser status to open' do
      dispenser_service = DispenserService.new(dispenser, admin_user)
      expect { dispenser_service.mark_tap_open }.to change { DispenserEvent.count }.by(1)
      expect(dispenser.reload.status).to be_truthy
    end
  end

  describe '#mark_tap_close' do
    it 'updates the last dispenser event to "close" type and calculatesliters and price' do
      dispenser_service = DispenserService.new(dispenser, admin_user)
      dispenser_service.mark_tap_open
      Timecop.freeze(Time.now + 1.hour) do
        expect { dispenser_service.mark_tap_close }.to change { dispenser.dispenser_events.last.end_time }.from(nil)
        expect(dispenser.reload.status).to be_falsy
        event = dispenser.dispenser_events.last
        expect(event.event_type).to eq('close')

        liters = dispenser.flow_volume * 1.hour

        expect(event.liters).to eq(liters)
        expect(event.price).to eq(liters * dispenser.price_per_liter) # For simplicity, assuming $1 per liter
      end
    end

    it 'does not update event if the dispenser event is already closed' do
      dispenser_service = DispenserService.new(dispenser, admin_user)
      dispenser_service.mark_tap_open
      dispenser_service.mark_tap_close

      expect { dispenser_service.mark_tap_close }.not_to change { dispenser.dispenser_events.last.end_time }
    end

    it 'does not update event if there are no events for the dispenser' do
      dispenser_service = DispenserService.new(dispenser, admin_user)

      expect { dispenser_service.mark_tap_close }.not_to change { DispenserEvent.count }
    end
  end
end
