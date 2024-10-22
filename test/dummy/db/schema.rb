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

ActiveRecord::Schema[7.1].define(version: 2024_10_22_153307) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billing_usage_counts", force: :cascade do |t|
    t.bigint "tracker_id", null: false
    t.string "name", null: false
    t.string "action", null: false
    t.integer "count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action", "name", "tracker_id"], name: "index_billing_usage_counts_on_action_and_name_and_tracker_id", unique: true
    t.index ["tracker_id"], name: "index_billing_usage_counts_on_tracker_id"
  end

  create_table "billing_usage_trackers", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "duration", null: false
    t.string "interval", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "trackable_id"
    t.string "trackable_type", default: "Team"
    t.index ["team_id"], name: "index_billing_usage_trackers_on_team_id"
    t.index ["trackable_id", "trackable_type"], name: "idx_on_trackable_id_trackable_type_f3d701ad36"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "billing_usage_counts", "billing_usage_trackers", column: "tracker_id"
  add_foreign_key "billing_usage_trackers", "teams"
end
