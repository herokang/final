class Answer < ActiveRecord::Base
  belongs_to :question,dependent: :delete, autosave: false
  def isRight()
    @realQuestion=question.transfer() if @realQuestion.nil?
    if question.questionType=Question::QuestionType[:selection]
      return record.split("").uniq().sort().join("")==@realQuestion.reference
    elsif question.questionType=Question::QuestionType[:judge]
      return @realQuestion.reference==record
    end
  end
end
