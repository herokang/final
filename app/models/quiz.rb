
class Quiz < ActiveRecord::Base
  has_many :questions, autosave: true,dependent: destroy
  STATUS={:unassigned=>0,:assigned=>1}
  def generate()
    @questionList=questions.map{|q| q.transfer()}
  end
end