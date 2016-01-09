class HomeWork < ActiveRecord::Base
  has_many :answers
  belongs_to :student
  belongs_to :quiz
  STATUS={:uncommited=>0,:commited=>1,:commented=>2}

  # @summary: 为作业评分
  def comment()

  end
end
