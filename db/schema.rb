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

ActiveRecord::Schema.define(version: 20140918150040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projections", force: true do |t|
    t.string   "player_name"
    t.integer  "player_id"
    t.string   "position"
    t.string   "team"
    t.decimal  "std_proj"
    t.decimal  "std_low_proj"
    t.decimal  "std_high_proj"
    t.decimal  "ppr_proj"
    t.decimal  "ppr_low_proj"
    t.decimal  "ppr_high_proj"
    t.string   "injury"
    t.string   "practice_status"
    t.string   "game_status"
    t.string   "last_update"
    t.integer  "week"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projections", ["position", "week", "year"], name: "index_projections_on_position_and_week_and_year", using: :btree
  add_index "projections", ["position"], name: "index_projections_on_position", using: :btree
  add_index "projections", ["week", "year"], name: "index_projections_on_week_and_year", using: :btree

end
