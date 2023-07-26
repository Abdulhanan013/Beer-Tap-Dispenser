# db/migrate/YYYYMMDDHHMMSS_create_dispenser_events.rb

class CreateDispenserEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :dispenser_events do |t|
      t.references :dispenser, null: false, foreign_key: true
      t.references :user, foreign_key: true # Add the user reference
      t.string :event_type
      t.datetime :start_time
      t.datetime :end_time
      t.float :liters
      t.float :price
      t.float :time


      t.timestamps
    end
  end
end
