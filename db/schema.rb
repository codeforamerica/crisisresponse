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

ActiveRecord::Schema.define(version: 20160729212645) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "aliases", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "person_id",  null: false
  end

  add_index "aliases", ["person_id"], name: "index_aliases_on_person_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "response_plan_id"
    t.string   "name"
    t.string   "relationship"
    t.string   "cell"
    t.string   "notes"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "organization"
  end

  add_index "contacts", ["response_plan_id"], name: "index_contacts_on_response_plan_id", using: :btree

  create_table "deescalation_techniques", force: :cascade do |t|
    t.string   "description",      null: false
    t.integer  "response_plan_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "deescalation_techniques", ["response_plan_id"], name: "index_deescalation_techniques_on_response_plan_id", using: :btree

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

  create_table "feedbacks", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "source",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "person_id",  null: false
  end

  add_index "images", ["person_id"], name: "index_images_on_person_id", using: :btree

  create_table "officers", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "unit"
    t.string   "title"
    t.string   "phone"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "username"
    t.string   "analytics_token"
  end

  add_index "officers", ["username"], name: "index_officers_on_username", unique: true, using: :btree

  create_table "people", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
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
    t.string   "analytics_token"
    t.string   "location_name"
    t.string   "location_address"
  end

  create_table "response_plans", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "author_id",       null: false
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.text     "background_info"
    t.text     "private_notes"
    t.integer  "person_id"
  end

  add_index "response_plans", ["approver_id"], name: "index_response_plans_on_approver_id", using: :btree
  add_index "response_plans", ["author_id"], name: "index_response_plans_on_author_id", using: :btree
  add_index "response_plans", ["person_id"], name: "index_response_plans_on_person_id", using: :btree

  create_table "response_strategies", force: :cascade do |t|
    t.integer  "priority"
    t.string   "title"
    t.text     "description"
    t.integer  "response_plan_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "response_strategies", ["response_plan_id"], name: "index_response_strategies_on_response_plan_id", using: :btree

  create_table "rms_crisis_incidents", force: :cascade do |t|
    t.integer  "rms_person_id",             null: false
    t.datetime "reported_at"
    t.string   "go_number"
    t.boolean  "weapon"
    t.boolean  "threaten_violence"
    t.boolean  "biologically_induced"
    t.boolean  "medically_induced"
    t.boolean  "chemically_induced"
    t.boolean  "unknown_crisis_nature"
    t.boolean  "neglect_self_care"
    t.boolean  "disorganize_communication"
    t.boolean  "disoriented_confused"
    t.boolean  "disorderly_disruptive"
    t.boolean  "unusual_fright_scared"
    t.boolean  "belligerent_uncooperative"
    t.boolean  "hopeless_depressed"
    t.boolean  "bizarre_unusual_behavior"
    t.boolean  "suicide_threat_attempt"
    t.boolean  "mania"
    t.boolean  "out_of_touch_reality"
    t.boolean  "halluc_delusion"
    t.boolean  "excited_delirium"
    t.boolean  "chronic"
    t.boolean  "treatment_referral"
    t.boolean  "resource_declined"
    t.boolean  "mobile_crisis_team"
    t.boolean  "grat"
    t.boolean  "shelter"
    t.boolean  "no_action_poss_necc"
    t.boolean  "casemanager_notice"
    t.boolean  "dmhp_refer"
    t.boolean  "crisis_clinic"
    t.boolean  "emergent_ita"
    t.boolean  "voluntary_commit"
    t.boolean  "arrested"
    t.boolean  "verbalization"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "rms_crisis_incidents", ["rms_person_id"], name: "index_rms_crisis_incidents_on_rms_person_id", using: :btree

  create_table "rms_people", force: :cascade do |t|
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
    t.string   "location_name"
    t.string   "location_address"
    t.string   "pin",              null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "safety_concerns", force: :cascade do |t|
    t.string   "description",        null: false
    t.integer  "response_plan_id",   null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "category",           null: false
    t.string   "physical_or_threat"
  end

  add_index "safety_concerns", ["response_plan_id"], name: "index_safety_concerns_on_response_plan_id", using: :btree

  create_table "triggers", force: :cascade do |t|
    t.string   "description",      null: false
    t.integer  "response_plan_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "triggers", ["response_plan_id"], name: "index_triggers_on_response_plan_id", using: :btree

  add_foreign_key "aliases", "people"
  add_foreign_key "contacts", "response_plans"
  add_foreign_key "deescalation_techniques", "response_plans"
  add_foreign_key "images", "people"
  add_foreign_key "response_plans", "people"
  add_foreign_key "response_strategies", "response_plans"
  add_foreign_key "rms_crisis_incidents", "rms_people"
  add_foreign_key "safety_concerns", "response_plans"
  add_foreign_key "triggers", "response_plans"
end
