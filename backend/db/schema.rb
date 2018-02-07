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

ActiveRecord::Schema.define(version: 20171222063355) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street_address", limit: 255
    t.string "suburb", limit: 255
    t.string "postcode", limit: 255
    t.string "state", limit: 255
    t.string "country", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
    t.boolean "status", default: false
    t.boolean "connected", default: false
    t.boolean "processing", default: false
    t.string "address"
    t.string "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "archived", default: false
    t.float "latitude"
    t.float "longitude"
    t.integer "address_id"
    t.string "timezone", limit: 255
    t.index ["address_id"], name: "index_locations_on_address_id"
  end

  create_table "logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "level", limit: 255, null: false
    t.string "category", limit: 255, null: false
    t.string "message", limit: 255, null: false
    t.integer "user_id"
    t.string "controller", limit: 255
    t.string "action", limit: 255
    t.json "data"
    t.string "notes", limit: 255
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "mobile_devices", force: :cascade do |t|
    t.string "vendor_registration_id", limit: 255
    t.string "platform", limit: 255
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_mobile_devices_on_user_id"
  end

  create_table "notification_metadata", force: :cascade do |t|
    t.string "subject", limit: 255
    t.text "message"
    t.json "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "notification_metadata_id", null: false
    t.boolean "seen", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["notification_metadata_id"], name: "index_notifications_on_notification_metadata_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "email", limit: 255
    t.datetime "last_active"
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "first_name", limit: 255, null: false
    t.string "last_name"
    t.date "date_of_birth"
    t.string "salutation", limit: 255
    t.boolean "archived", default: false
    t.integer "address_id"
    t.string "preferred_name", limit: 255
    t.string "gender", limit: 255, default: "Unspecified"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "phone_number"
    t.boolean "onboarded", default: false
    t.index ["address_id"], name: "index_profiles_on_address_id"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token", limit: 64, null: false
    t.datetime "failed_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token", limit: 64
    t.string "sound", default: "default"
    t.string "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at"
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at"
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "alert_is_json", default: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after"
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false
    t.index ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "name"
    t.string "action"
    t.boolean "repeat", default: false
    t.integer "hour"
    t.integer "minute"
    t.json "repeat_days", default: [{"day"=>1, "run"=>false}, {"day"=>2, "run"=>false}, {"day"=>3, "run"=>false}, {"day"=>4, "run"=>false}, {"day"=>5, "run"=>false}, {"day"=>6, "run"=>false}, {"day"=>7, "run"=>false}]
    t.bigint "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_schedules_on_device_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "authentication_token", limit: 255
    t.boolean "superuser", default: false, null: false
    t.boolean "archived", default: false
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "schedules", "devices"
end
