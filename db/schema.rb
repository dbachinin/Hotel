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

ActiveRecord::Schema.define(version: 20170901132448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.integer "hotel_id"
    t.integer "room_id"
    t.boolean "booked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "subtotal"
    t.bigint "user_id"
    t.text "ad_service", default: [], array: true
    t.integer "discount"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.float "price"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "room_id"
    t.index ["room_id"], name: "index_prices_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "bed"
    t.boolean "lux"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hotel_id"
    t.integer "count"
    t.index ["hotel_id"], name: "index_rooms_on_hotel_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.boolean "enable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "booking_id"
    t.index ["booking_id"], name: "index_services_on_booking_id"
  end

  create_table "taryphs", force: :cascade do |t|
    t.date "udate"
    t.date "edate"
    t.float "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "price_id"
    t.index ["price_id"], name: "index_taryphs_on_price_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "provider"
    t.string "uid"
    t.string "firstname"
    t.string "lastname"
    t.string "login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discount", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "users"
  add_foreign_key "prices", "rooms"
  add_foreign_key "rooms", "hotels"
  add_foreign_key "services", "bookings"
  add_foreign_key "taryphs", "prices"
end
