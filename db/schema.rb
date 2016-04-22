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

ActiveRecord::Schema.define(version: 20160422003255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "contacts", force: :cascade do |t|
    t.integer  "person_id"
    t.string   "name"
    t.string   "relationship"
    t.string   "cell"
    t.string   "notes"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "contacts", ["person_id"], name: "index_contacts_on_person_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "people", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "sex"
    t.string   "race"
    t.integer  "height_in_inches"
    t.integer  "weight_in_pounds"
    t.string   "hair_color"
    t.string   "eye_color"
    t.date     "date_of_birth"
    t.string   "scars_and_marks"
    t.string   "image"
    t.string   "gun_warning"
    t.string   "knife_warning"
    t.string   "needle_warning"
    t.string   "other_weapon_warning"
    t.string   "police_assault_warning"
    t.string   "spit_warning"
    t.string   "suicide_by_cop_warning"
    t.string   "violence_warning"
  end

  create_table "response_strategies", force: :cascade do |t|
    t.integer  "priority"
    t.string   "title"
    t.text     "description"
    t.integer  "person_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "response_strategies", ["person_id"], name: "index_response_strategies_on_person_id", using: :btree

  add_foreign_key "contacts", "people"
  add_foreign_key "response_strategies", "people"
end
