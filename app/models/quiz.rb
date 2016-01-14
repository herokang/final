
class Quiz < ActiveRecord::Base
  has_many :questions, autosave: true,dependent: :destroy
  belongs_to :lesson, autosave: false, dependent: :delete
  STATUS={:unassigned=>0,:assigned=>1,:over=>2}
  after_initialize :init
  def init
    self.status ||=STATUS[:unassigned]
  end
  def generate()
    tmp=nil

    questionList=Question.where(quiz_id: self.id)
    if not questionList.nil?
      tmp=questionList.map{|q| q.transfer()}
    end

    # @questionList=tmp
    return tmp
  end

  def isGenerated(student)
    return HomeWork.exists?(quizId:self.id,student_id:student.id)
  end
end