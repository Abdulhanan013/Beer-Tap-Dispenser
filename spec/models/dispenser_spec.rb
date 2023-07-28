# spec/models/dispenser_spec.rb

require 'rails_helper'

RSpec.describe Dispenser, type: :model do
  let(:admin_user) { User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', role: 'admin') }
  let(:attendee_user) { User.create(name: 'Attendee User', email: 'attendee@example.com', password: 'password', role: 'attendee') }
  let!(:dispenser1) { Dispenser.create(name: 'Test Dispenser 1', flow_volume: 10, user: admin_user) }
  let!(:dispenser2) { Dispenser.create(name: 'Test Dispenser 2', flow_volume: 20, user: admin_user) }

  describe 'validations' do
    it { should validate_presence_of(:flow_volume) }
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:dispenser_events).dependent(:destroy) }
  end

  describe '#total_usage_count' do
    it 'returns the count of dispenser events' do
      dispenser1.dispenser_events.create(event_type: 'open', start_time: Time.now - 2.hours, user_id: admin_user.id)
      dispenser1.dispenser_events.create(event_type: 'close', start_time: Time.now - 1.hour, end_time: Time.now, user_id: admin_user.id)

      expect(dispenser1.total_usage_count).to eq(2)
    end
  end

  describe '#total_usage_time' do
    it 'returns the total usage time for dispenser events with end_time' do
      dispenser1.dispenser_events.create(event_type: 'open', start_time: Time.now - 2.hours, user_id: admin_user.id)
      dispenser1.dispenser_events.create(event_type: 'close', start_time: Time.now - 1.hour, end_time: Time.now, user_id: admin_user.id)

      expect(dispenser1.total_usage_time).to eq(3600) # 1 hour in seconds
    end
  end

  describe '#total_earnings' do
    it 'returns the total earnings from dispenser events with event_type "close"' do
      dispenser1.dispenser_events.create(event_type: 'open', start_time: Time.now - 2.hours, user_id: admin_user.id)
      dispenser1.dispenser_events.create(event_type: 'close', start_time: Time.now - 1.hour, end_time: Time.now, user_id: admin_user.id, price: 5)

      expect(dispenser1.total_earnings).to eq(5)
    end
  end

  describe '.total_earnings_for_all_dispensers' do
    it 'returns the total earnings for all dispensers' do
      dispenser1.dispenser_events.create(event_type: 'open', start_time: Time.now - 2.hours, user_id: admin_user.id)
      dispenser1.dispenser_events.update(event_type: 'close', start_time: Time.now - 1.hour, end_time: Time.now, user_id: admin_user.id, price: 5)

      dispenser2.dispenser_events.create(event_type: 'open', start_time: Time.now - 3.hours, user_id: admin_user.id)
      dispenser2.dispenser_events.update(event_type: 'close', start_time: Time.now - 1.5.hours, end_time: Time.now, user_id: admin_user.id, price: 8)

      total_earnings = Dispenser.total_earnings_for_all_dispensers
      expect(total_earnings).to eq(13)
    end
  end

  describe '.total_usage_time_for_all_dispensers' do
    it 'returns the total usage time for all dispensers' do
      dispenser1.dispenser_events.create(event_type: 'open', start_time: Time.now - 1.hours, user_id: admin_user.id)
      dispenser1.dispenser_events.update(event_type: 'close', end_time: Time.now, user_id: admin_user.id)

      dispenser2.dispenser_events.create(event_type: 'open', start_time: Time.now - 1.hours, user_id: admin_user.id)
      dispenser2.dispenser_events.update(event_type: 'close', end_time: Time.now, user_id: admin_user.id)

      total_usage_time = Dispenser.total_usage_time_for_all_dispensers
      expect(total_usage_time).to eq(7200) # 1 hour + 1.5 hours in seconds
    end
  end
end
