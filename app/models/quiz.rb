
class Quiz < ActiveRecord::Base
  has_many :questions
  belongs_to :lesson
  STATUS={:unassigned=>0,:assigned=>1}
  def generate()
    @questionList=questions.map{|q| q.transfer()}
  end
end