# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150916041021) do

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "vendor_id"
    t.string   "platform"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale"
    t.boolean  "location_enabled"
    t.string   "notification_token"
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "notes", force: true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "impact"
    t.string   "feeling"
    t.integer  "impact_score"
    t.integer  "feeling_score"
    t.string   "address"
    t.string   "city"
    t.string   "suburb"
    t.string   "country"
    t.float    "latitude",       limit: 24
    t.float    "longitude",      limit: 24
    t.datetime "recorded_at"
    t.string   "original_image_path", limit: 500
    t.string   "thumb_image_path",    limit: 500
  end

  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "bundle_name_ios"
    t.string   "bundle_name_android"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration_in_months"
    t.boolean  "on_sale"
  end

  add_index "products", ["bundle_name_android"], name: "index_products_on_bundle_name_android", using: :btree
  add_index "products", ["bundle_name_ios"], name: "index_products_on_bundle_name_ios", using: :btree

  create_table "receipts", force: true do |t|
    t.text     "receipt",    limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "platform"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.integer  "note_id"
    t.integer  "index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree
  add_index "tags", ["note_id"], name: "index_tags_on_note_id", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "user_id"
    t.datetime "orig_purchase_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bundle_name"
    t.integer  "product_id"
    t.text     "transaction_number"
    t.integer  "receipt_id"
    t.integer  "subscription_id"
  end

  add_index "transactions", ["bundle_name"], name: "index_transactions_on_bundle_name", using: :btree
  add_index "transactions", ["user_id"], name: "index_transactions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "encrypted_email"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_activity"
    t.integer  "login_count"
    t.integer  "app_opens_count"
    t.datetime "auth_token_created_at"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", using: :btree

end