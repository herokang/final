require 'json'



class Question < ActiveRecord::Base
  QuestionType={:selection => 0,:judge => 1}
  def transfer()
    case questionType
      when QuestionType[:selection]
        optionList=JSON.parse options
        return SelectQuestion(description,optionList,reference,score)
      when QuestionType[:judge]
        return JudgeQuestion(description,reference,score)
  end
  end
end


class RealQuestion
=begin
  summary:本类是数据库中存取的Question转化而来的虚类
=end

  def toQuestion()
    #存入数据库时调用该函数
  end

end

class SelectQuestion < RealQuestion
  def initialize(description,options,reference,score)
    @description=description
    @options=options
    @reference=reference
    @score=score
  end

end

class JudgeQuestion < RealQuestion
  def initialize(description,reference,score)
    @description=description
    @reference=reference
    @score=score
  end
end