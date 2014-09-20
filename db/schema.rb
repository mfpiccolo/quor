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

ActiveRecord::Schema.define(version: 20140901000427) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"

  create_table "email_templates", force: true do |t|
    t.integer  "user_id"
    t.string   "logo_file"
    t.string   "banner_file"
    t.text     "subject"
    t.string   "header1_large"
    t.text     "header1_small"
    t.text     "banner_description"
    t.string   "header2_large"
    t.string   "header2_small"
    t.text     "body"
    t.string   "call_to_action"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "google_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filters", force: true do |t|
    t.integer "user_id"
    t.string  "model_type"
    t.text    "query"
    t.string  "name"
  end

  create_table "model_mappings", force: true do |t|
    t.integer  "user_id"
    t.string   "otype"
    t.json     "type_mapping"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "oid"
    t.string   "otype"
    t.json     "data",                 default: {}
    t.hstore   "ohash"
    t.datetime "last_modified"
    t.datetime "last_checked"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "last_version_changes", default: {}
    t.integer  "model_state_id"
    t.string   "state"
  end

  create_table "ply_relations", force: true do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.integer  "child_id"
    t.string   "child_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
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

  create_table "workflows", force: true do |t|
    t.integer  "user_id"
    t.string   "model_otype"
    t.text     "trigger_text"
    t.string   "trigger_subject"
    t.string   "trigger_function"
    t.string   "trigger_arg"
    t.text     "condition_text"
    t.string   "condition_subject"
    t.string   "condition_function"
    t.string   "condition_arg"
    t.text     "action_text"
    t.string   "action_function"
    t.string   "action_subject"
    t.string   "action_arg"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

end
