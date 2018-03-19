# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180319051951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendees", force: :cascade do |t|
    t.bigint "trip_id"
    t.bigint "user_id"
    t.integer "balance_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_attendees_on_trip_id"
    t.index ["user_id"], name: "index_attendees_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "trip_id"
    t.bigint "user_id"
    t.integer "amount_cents"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_expenses_on_trip_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "trip_id"
    t.bigint "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_messages_on_trip_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "payees", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "expense_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_payees_on_expense_id"
    t.index ["user_id"], name: "index_payees_on_user_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "name"
    t.string "accomodation_url"
    t.string "start_location"
    t.string "end_location"
    t.integer "price_per_night_cents"
    t.integer "number_of_possible_attendees"
    t.date "start_date"
    t.date "end_date"
    t.integer "total_possible_cost_cents"
    t.integer "total_confirmed_cost_cents"
    t.string "type_of_trip"
    t.boolean "started"
    t.boolean "ended"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "attendees", "trips"
  add_foreign_key "attendees", "users"
  add_foreign_key "expenses", "trips"
  add_foreign_key "expenses", "users"
  add_foreign_key "messages", "trips"
  add_foreign_key "messages", "users"
  add_foreign_key "payees", "expenses"
  add_foreign_key "payees", "users"
end
