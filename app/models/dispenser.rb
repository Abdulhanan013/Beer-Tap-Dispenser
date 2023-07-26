class Dispenser < ApplicationRecord
    belongs_to :user
    has_many :dispenser_events, dependent: :destroy

    validates :flow_volume, :name ,presence: true
  
    def total_revenue
      dispenser_events.where(event_type: 'close').sum(:price)
    end
  end
  