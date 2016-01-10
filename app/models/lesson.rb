class Lesson < ActiveRecord::Base
  belongs_to :teacher, autosave: false,dependent: delete
  has_many :students, through: :assignments, autosave: false
  has_many :quizs, dependent: destroy, autosave: false
  STATUS={:attendable=>0,:active=>1,:over=>2}
  after_initialize :init
  def init
    self.status=STATUS[:attendable]
  end
end
