class Assignment < ActiveRecord::Base
  belongs_to :student
  belongs_to :lesson
end
