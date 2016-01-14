class Answer < ActiveRecord::Base
  belongs_to :question,dependent: :delete, autosave: false
  # belongs_to :home_work, dependent: :delete, autosave: false
  def discriminate()
    question=Question.find(self.question_id)
    realQuestion=question.transfer()
    flag=true
    if question.questionType<Question::QuestionType[:judge]
      flag=self.solution.split("").uniq().sort().join("")==realQuestion.reference.split("").uniq().sort().join("")
    elsif question.questionType=Question::QuestionType[:judge]
      flag=(realQuestion.reference==self.solution)
    end
    self.right=flag
    return flag
  end
end
