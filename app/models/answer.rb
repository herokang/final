class Answer < ActiveRecord::Base
  belongs_to :question,dependent: :delete, autosave: false
  def discriminate()
    @realQuestion=@question.transfer() if @realQuestion.nil?
    flag=true
    if @question.questionType=Question::QuestionType[:selection]
      flag=record.split("").uniq().sort().join("")==@realQuestion.reference
    elsif @question.questionType=Question::QuestionType[:judge]
      flag=@realQuestion.reference==record
    end
    self.right=flag
    return flag
  end
end
