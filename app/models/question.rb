require 'json'
require_relative "../utils/my_exception"
require_relative "../helpers/questions_helper"


class Question < ActiveRecord::Base
  include QuestionsHelper
  QuestionType={:single=>0,:selection => 1,:judge => 2}
  after_initialize :init
  def init
    self.ratio ||=0.0
    self.correct ||=0
    self.count ||=0
  end
  def transfer()

    info={:description => self.description,:score => self.score,
          :reference => self.reference, :id=>self.id, :questionType=>self.questionType}
    case questionType
      when QuestionType[:selection]
        # info[:options]=JSON.parse self.options
        info[:options]=ActiveSupport::JSON.decode(self.options)
        return SelectQuestion.new(info)
      when QuestionType[:single]
        info[:options]=ActiveSupport::JSON.decode(self.options)
        return SingleQuestion.new(info)
      when QuestionType[:judge]
        return JudgeQuestion.new(info)
      else
        return nil
    end
  end

  # @summary: 计算本题的正确率
  def coverage
    self.ratio=1.0*self.correct/self.count
    return self.ratio
  end
end


