
class Quiz < ActiveRecord::Base
  has_many :questions, autosave: true,dependent: :destroy
  belongs_to :lesson, autosave: false, dependent: :delete
  STATUS={:unassigned=>0,:assigned=>1,:over=>2}
  after_initialize :init
  def init
    self.status ||=STATUS[:unassigned]
  end
  def generate()
    tmp=@questions.map{|q| q.transfer()}
    # @questionList=tmp
    return tmp
  end
end