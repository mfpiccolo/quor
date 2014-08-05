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

ActiveRecord::Schema.define(version: 20140805070026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"

  create_table "filters", force: true do |t|
    t.integer "user_id"
    t.string  "model_type", limit: 255
    t.text    "query"
    t.string  "name",       limit: 255
  end

  create_table "model_states", force: true do |t|
    t.string   "name"
    t.string   "otype"
    t.string   "transition_to"
    t.string   "transition_from"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "plies", force: true do |t|
    t.integer  "user_id"
    t.string   "oid",                  limit: 255
    t.string   "otype",                limit: 255
    t.json     "data",                             default: {}
    t.hstore   "ohash"
    t.datetime "last_modified"
    t.datetime "last_checked"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "last_version_changes",             default: {}
    t.integer  "model_state_id"
    t.string   "state"
  end

  create_table "ply_relations", force: true do |t|
    t.integer  "parent_id"
    t.string   "parent_type", limit: 255
    t.integer  "child_id"
    t.string   "child_type",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",       null: false
    t.integer  "item_id",         null: false
    t.string   "event",           null: false
    t.string   "whodunnit"
    t.string   "whodunnit_email"
    t.text     "object"
    t.string   "otype"
    t.json     "diff"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
