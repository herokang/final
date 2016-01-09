class Lesson < ActiveRecord::Base
  belongs_to :teacher
  has_and_belongs_to_many :students
  has_many :quizs
end
