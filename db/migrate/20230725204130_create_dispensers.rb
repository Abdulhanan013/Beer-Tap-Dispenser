# db/migrate/YYYYMMDDHHMMSS_create_dispensers.rb

class CreateDispensers < ActiveRecord::Migration[6.1]
  def change
    create_table :dispensers do |t|
      t.float :flow_volume
      t.string :name
      t.boolean :status, default: false
      t.references :user, foreign_key: true # Add the user reference

      t.timestamps
    end
  end
end
