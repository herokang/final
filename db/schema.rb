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

ActiveRecord::Schema.define(version: 20160114025446) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.integer  "home_work_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score"
    t.string   "solution"
  end

  create_table "assignments", force: true do |t|
    t.integer  "student_id"
    t.integer  "lesson_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_works", force: true do |t|
    t.integer  "grade"
    t.datetime "lastModified"
    t.integer  "status"
    t.integer  "quizId"
    t.integer  "interval"
    t.text     "comment"
    t.integer  "student_id"
    t.datetime "start"
    t.string   "title"
  end

  create_table "lessons", force: true do |t|
    t.string   "name"
    t.string   "lessonNo"
    t.integer  "limit"
    t.integer  "status"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "credit"
    t.string   "semester"
  end

  create_table "questions", force: true do |t|
    t.text     "description"
    t.text     "options"
    t.string   "reference"
    t.integer  "score"
    t.integer  "questionType"
    t.integer  "quiz_id"
    t.float    "ratio"
    t.integer  "count"
    t.integer  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quizs", force: true do |t|
    t.datetime "lastModified"
    t.integer  "status"
    t.integer  "lesson_id"
    t.integer  "limitTime"
    t.integer  "number"
    t.string   "title"
    t.text     "demand"
    t.integer  "highest"
    t.integer  "lowest"
    t.float    "average"
  end

  create_table "students", force: true do |t|
    t.string   "studentNo"
    t.boolean  "binded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", force: true do |t|
    t.string   "teacherNo"
    t.boolean  "binded"
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
    t.integer  "student_id"
    t.integer  "teacher_id"
    t.string   "avatar"
    t.boolean  "verified"
  end

end
