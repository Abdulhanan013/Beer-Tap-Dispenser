# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_25_204201) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dispenser_events", force: :cascade do |t|
    t.bigint "dispenser_id", null: false
    t.bigint "user_id"
    t.string "event_type"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.float "liters"
    t.float "price"
    t.float "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dispenser_id"], name: "index_dispenser_events_on_dispenser_id"
    t.index ["user_id"], name: "index_dispenser_events_on_user_id"
  end

  create_table "dispensers", force: :cascade do |t|
    t.float "flow_volume"
    t.float "price_per_liter"
    t.string "name"
    t.boolean "status", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_dispensers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "dispenser_events", "dispensers"
  add_foreign_key "dispenser_events", "users"
  add_foreign_key "dispensers", "users"
end
