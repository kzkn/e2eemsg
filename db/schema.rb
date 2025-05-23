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

ActiveRecord::Schema[8.0].define(version: 2025_05_23_084837) do
  create_table "memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_memberships_on_room_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "message_reads", force: :cascade do |t|
    t.integer "message_id", null: false
    t.integer "membership_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_id"], name: "index_message_reads_on_membership_id"
    t.index ["message_id", "membership_id"], name: "index_message_reads_on_message_id_and_membership_id", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "from_id", null: false
    t.string "sendable_type", null: false
    t.integer "sendable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id"], name: "index_messages_on_from_id"
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["sendable_type", "sendable_id"], name: "index_messages_on_sendable"
  end

  create_table "one_to_one_chats", force: :cascade do |t|
    t.integer "smaller_user_id", null: false
    t.integer "larger_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["larger_user_id"], name: "index_one_to_one_chats_on_larger_user_id"
    t.index ["smaller_user_id", "larger_user_id"], name: "index_one_to_one_chats_on_smaller_user_id_and_larger_user_id", unique: true
  end

  create_table "rooms", force: :cascade do |t|
    t.string "joinable_type", null: false
    t.integer "joinable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["joinable_type", "joinable_id"], name: "index_rooms_on_joinable"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "text_messages", force: :cascade do |t|
    t.string "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "memberships", "rooms"
  add_foreign_key "memberships", "users"
  add_foreign_key "message_reads", "memberships"
  add_foreign_key "message_reads", "messages"
  add_foreign_key "messages", "memberships", column: "from_id"
  add_foreign_key "messages", "rooms"
  add_foreign_key "one_to_one_chats", "users", column: "larger_user_id"
  add_foreign_key "one_to_one_chats", "users", column: "smaller_user_id"
  add_foreign_key "sessions", "users"
end
