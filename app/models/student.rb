class Student < ActiveRecord::Base
  has_many :home_works
  has_and_belongs_to_many :lessons
  has_one :user
end
