class DispenserEvent < ApplicationRecord
  belongs_to :dispenser
  belongs_to :user

  validates :dispenser, :event_type, :start_time, presence: true
end
