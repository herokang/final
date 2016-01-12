require 'json'



class Question < ActiveRecord::Base
  QuestionType={:selection => 0,:judge => 1}
  after_initialize :init
  def init
    self.ratio=0.0
  end
  def transfer()

    info={:descrption => self.description,:score => self.score, :reference => self.reference, :id=>self.id}
    case questionType
      when QuestionType[:selection]
        info[:options]=JSON.parse self.options
        return SelectQuestion(info)
      when QuestionType[:judge]
        return JudgeQuestion(info)
    end
  end
end


class RealQuestion
=begin
  summary:本类是数据库中存取的Question转化而来的虚类
=end

  def jsonMap
    #返回存入数据库时实际的字典
  end

end

class SelectQuestion < RealQuestion

  # 从哈希构造实体
  def initialize(info)
    @description=info[:descrption]
    @options=info[:options]
    @score=info[:score]
    @reference=info[:reference]
  end

  def jsonMap

  end

end

class JudgeQuestion < RealQuestion
  # 从哈希构造实体
  def initialize(info)
    @description=info[:descrption]
    @score=info[:score]
    @reference=info[:reference]
  end

  def jsonMap

  end
end