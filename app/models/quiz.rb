
class Quiz < ActiveRecord::Base
  has_many :questions, autosave: true,dependent: :destroy
  has_many :home_works,autosave: false,dependent: destroy
  belongs_to :lesson, autosave: false, dependent: :delete
  STATUS={:unassigned=>0,:assigned=>1,:over=>2}
  after_initialize :init
  def init
    self.status ||=STATUS[:unassigned]
  end
  def generate()
    @questionList=@questions.map{|q| q.transfer()}
  end
end