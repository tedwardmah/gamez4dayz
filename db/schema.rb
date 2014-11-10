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

ActiveRecord::Schema.define(version: 20141109235527) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hangman_games", force: true do |t|
    t.integer  "user_id"
    t.string   "secret_word"
    t.string   "guessed_letters",    default: ""
    t.integer  "tries",              default: 6
    t.boolean  "last_guess_correct"
    t.boolean  "win",                default: false
    t.boolean  "game_completed",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plays", force: true do |t|
    t.integer  "user_id"
    t.integer  "tictactoe_game_id"
    t.integer  "opponent_id"
    t.boolean  "is_player_1"
    t.boolean  "win",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tictactoe_games", force: true do |t|
    t.integer  "user_id"
    t.string   "board_state",    default: "012345678"
    t.string   "x_moves",        default: ""
    t.string   "o_moves",        default: ""
    t.boolean  "game_completed", default: false
    t.boolean  "player1_turn",   default: true
    t.string   "winner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",      null: false
    t.string   "password_hash", null: false
    t.string   "email",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
