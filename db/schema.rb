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

ActiveRecord::Schema.define(version: 20160109115540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.text     "record"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_works", force: true do |t|
    t.integer  "grade"
    t.datetime "lastModified"
    t.integer  "status"
  end

  create_table "lessons", force: true do |t|
    t.string   "name"
    t.string   "lessonNo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.text     "description"
    t.text     "options"
    t.string   "reference"
    t.integer  "score"
    t.integer  "questionType"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quizs", force: true do |t|
    t.datetime "lastModified"
    t.integer  "status"
  end

  create_table "students", force: true do |t|
    t.string   "studentNo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", force: true do |t|
    t.string   "teacherNo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account"
    t.string   "password"
    t.string   "email"
    t.string   "name"
    t.integer  "userType"
  end

end
