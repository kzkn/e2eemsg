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

ActiveRecord::Schema[8.0].define(version: 2025_05_23_212032) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blocks", force: :cascade do |t|
    t.integer "blocker_id", null: false
    t.integer "blockee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blockee_id"], name: "index_blocks_on_blockee_id"
    t.index ["blocker_id", "blockee_id"], name: "index_blocks_on_blocker_id_and_blockee_id", unique: true
  end

  create_table "emojis", force: :cascade do |t|
    t.string "name", null: false
    t.json "definition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_emojis_on_name", unique: true
  end

  create_table "image_messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "reactions", force: :cascade do |t|
    t.integer "message_id", null: false
    t.integer "from_id", null: false
    t.integer "emoji_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emoji_id"], name: "index_reactions_on_emoji_id"
    t.index ["from_id"], name: "index_reactions_on_from_id"
    t.index ["message_id", "from_id", "emoji_id"], name: "index_reactions_on_message_id_and_from_id_and_emoji_id", unique: true
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

  create_table "stamp_messages", force: :cascade do |t|
    t.integer "stamp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stamp_id"], name: "index_stamp_messages_on_stamp_id"
  end

  create_table "stamp_ownerships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "stamp_set_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stamp_set_id"], name: "index_stamp_ownerships_on_stamp_set_id"
    t.index ["user_id", "stamp_set_id"], name: "index_stamp_ownerships_on_user_id_and_stamp_set_id", unique: true
  end

  create_table "stamp_sets", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stamp_sets_on_name", unique: true
  end

  create_table "stamps", force: :cascade do |t|
    t.integer "stamp_set_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stamp_set_id"], name: "index_stamps_on_stamp_set_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blocks", "users", column: "blockee_id"
  add_foreign_key "blocks", "users", column: "blocker_id"
  add_foreign_key "memberships", "rooms"
  add_foreign_key "memberships", "users"
  add_foreign_key "message_reads", "memberships"
  add_foreign_key "message_reads", "messages"
  add_foreign_key "messages", "memberships", column: "from_id"
  add_foreign_key "messages", "rooms"
  add_foreign_key "one_to_one_chats", "users", column: "larger_user_id"
  add_foreign_key "one_to_one_chats", "users", column: "smaller_user_id"
  add_foreign_key "reactions", "emojis"
  add_foreign_key "reactions", "memberships", column: "from_id"
  add_foreign_key "reactions", "messages"
  add_foreign_key "sessions", "users"
  add_foreign_key "stamp_messages", "stamps"
  add_foreign_key "stamp_ownerships", "stamp_sets"
  add_foreign_key "stamp_ownerships", "users"
  add_foreign_key "stamps", "stamp_sets"
end
