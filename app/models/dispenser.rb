class Dispenser < ApplicationRecord
    belongs_to :user
    has_many :dispenser_events, dependent: :destroy

    validates :flow_volume, :name ,presence: true
  
    def total_usage_count
        dispenser_events.count
    end

    def total_usage_time
    dispenser_events.where.not(end_time: nil).sum { |event| (event.end_time - event.start_time).to_i }
    end

    def total_earnings
        dispenser_events.where(event_type: 'close').sum(:price)
    end

    def self.total_earnings_for_all_dispensers
        sum = 0
        all.each { |dispenser| sum += dispenser.total_earnings }
        sum
    end

    def self.total_usage_time_for_all_dispensers
        sum = 0
        all.each { |dispenser| sum += dispenser.total_usage_time }
        sum
    end
  end
  