class Lesson < ActiveRecord::Base
  belongs_to :teacher, autosave: false,dependent: :delete
  has_many :assignments, autosave: true, dependent: :destroy
  has_many :students, through: :assignments, autosave: false
  has_many :quizs, dependent: :destroy, autosave: false
  STATUS={:attendable=>0,:active=>1,:over=>2}
  after_initialize :init
  def init
    self.status ||=STATUS[:attendable]
    self.limit ||=100
  end

  def isAttend(student)
    return true if Assignment.exists?(lesson_id:self.id,student_id:student.id)
  end

end
