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

ActiveRecord::Schema.define(version: 2019_07_25_213813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "series", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.bigint "speaker_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sermons_count", default: 0, null: false
    t.index ["slug"], name: "index_series_on_slug", unique: true
    t.index ["speaker_id"], name: "index_series_on_speaker_id"
  end

  create_table "sermons", id: :serial, force: :cascade do |t|
    t.text "audio_data"
    t.string "identifier"
    t.datetime "recorded_at"
    t.string "title"
    t.string "scripture_focus"
    t.string "scripture_reading"
    t.boolean "scripture_reading_might_be_focus"
    t.string "speaker_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "speaker_id"
    t.bigint "series_id"
    t.integer "series_index"
    t.index ["series_id"], name: "index_sermons_on_series_id"
    t.index ["speaker_id"], name: "index_sermons_on_speaker_id"
  end

  create_table "speakers", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "aliases", default: [], array: true
    t.text "photo_data"
    t.text "description"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_speakers_on_name", unique: true
    t.index ["slug"], name: "index_speakers_on_slug", unique: true
  end

  add_foreign_key "series", "speakers"
  add_foreign_key "sermons", "series"
  add_foreign_key "sermons", "speakers"
end
