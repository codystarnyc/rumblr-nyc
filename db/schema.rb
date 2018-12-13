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

ActiveRecord::Schema.define(version: 2018_12_12_063302) do

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
  end

  create_table "post_tags", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.date "date"
    t.integer "user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "username"
    t.string "password"
    t.date "birthday"
  end

end
