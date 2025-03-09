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

ActiveRecord::Schema[8.0].define(version: 2025_02_05_023156) do
  create_table "event_themes", id: :string, force: :cascade do |t|
    t.string "event_id", null: false
    t.string "main_color", default: "#0B374D", null: false
    t.string "sub_color", default: "#EBE0CE", null: false
    t.string "accent_color", default: "#D7D165", null: false
    t.string "overview", default: "", null: false
    t.string "site_label", default: "", null: false
    t.string "site_url", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "text_color", default: "#23221F", null: false
  end

  create_table "event_trophies", id: :string, force: :cascade do |t|
    t.string "event_id", null: false
    t.string "trophy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "trophy_id"], name: "index_event_trophies_on_event_id_and_trophy_id", unique: true
    t.index ["event_id"], name: "index_event_trophies_on_event_id"
    t.index ["trophy_id"], name: "index_event_trophies_on_trophy_id"
  end

  create_table "events", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friends", id: :string, force: :cascade do |t|
    t.string "from", null: false
    t.string "to", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from", "to"], name: "index_friends_on_from_and_to", unique: true
  end

  create_table "plan_schedules", id: :string, force: :cascade do |t|
    t.string "plan_id", null: false
    t.string "schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "memo", default: "", null: false
  end

  create_table "plans", id: :string, force: :cascade do |t|
    t.string "title", null: false
    t.string "description", default: "", null: false
    t.string "user_id", null: false
    t.boolean "public", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_hash"
    t.boolean "initial", default: true, null: false
    t.string "event_id", null: false
  end

  create_table "profile_trophies", id: :string, force: :cascade do |t|
    t.string "profile_id", null: false
    t.string "trophy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_profile_trophies_on_profile_id"
    t.index ["trophy_id"], name: "index_profile_trophies_on_trophy_id"
  end

  create_table "profiles", id: :string, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "name", null: false
    t.string "avatar_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "introduce"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "schedule_speakers", id: :string, force: :cascade do |t|
    t.string "schedule_id", null: false
    t.string "speaker_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", id: :string, force: :cascade do |t|
    t.string "title", null: false
    t.string "description", default: "", null: false
    t.datetime "start_at", precision: nil, null: false
    t.datetime "end_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language", default: 0, null: false
    t.string "track_id", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "speakers", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.string "handle", default: "", null: false
    t.string "thumbnail", default: "", null: false
    t.string "profile", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "github"
    t.string "twitter"
    t.string "event_id", null: false
  end

  create_table "team_profiles", id: :string, force: :cascade do |t|
    t.string "team_id", null: false
    t.string "profile_id", null: false
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_team_profiles_on_profile_id"
    t.index ["team_id", "profile_id"], name: "index_team_profiles_on_team_id_and_profile_id", unique: true
    t.index ["team_id"], name: "index_team_profiles_on_team_id"
  end

  create_table "teams", id: :string, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", id: :string, force: :cascade do |t|
    t.string "event_id", null: false
    t.string "name", null: false
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "name"], name: "index_tracks_on_event_id_and_name", unique: true
    t.index ["event_id"], name: "index_tracks_on_event_id"
  end

  create_table "triggers", id: :string, force: :cascade do |t|
    t.string "description", null: false
    t.string "key", null: false
    t.json "action", null: false
    t.integer "amount", null: false
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "conditions", default: []
  end

  create_table "trophies", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.string "icon_url", null: false
    t.integer "rarity", default: 0, null: false
    t.integer "order", default: 9999, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "special", default: false, null: false
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
  end

  add_foreign_key "event_trophies", "events"
  add_foreign_key "event_trophies", "trophies"
  add_foreign_key "friends", "profiles", column: "from"
  add_foreign_key "friends", "profiles", column: "to"
  add_foreign_key "profile_trophies", "profiles"
  add_foreign_key "profile_trophies", "trophies"
  add_foreign_key "profiles", "users"
  add_foreign_key "schedules", "tracks"
  add_foreign_key "team_profiles", "profiles"
  add_foreign_key "team_profiles", "teams"
  add_foreign_key "tracks", "events"
end
