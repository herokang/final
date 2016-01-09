class Lesson < ActiveRecord::Base
  belongs_to :teacher
  # has_and_belongs_to_many :students
  #被我注释掉的一句有问题，提示"PG::UndefinedTable: 错误: 关系 "lessons_students" 不存在"
  #等待suemi修复
  has_many :quizs
end
