require 'json'
require_relative "../utils/my_exception"



class Question < ActiveRecord::Base
  QuestionType={:single=>0,:selection => 1,:judge => 2}
  after_initialize :init
  def init
    self.ratio ||=0.0
    self.correct ||=0
    self.count ||=0
  end
  def transfer()

    info={:descrption => self.description,:score => self.score,
          :reference => self.reference, :id=>self.id, :questionType=>self.questionType}
    case questionType
      when QuestionType[:selection]
        # info[:options]=JSON.parse self.options
        info[:options]=ActiveSupport::JSON.decode(self.options)
        return SelectQuestion(info)
      when QuestionType[:judge]
        return JudgeQuestion(info)
    end
  end

  # @summary: 计算本题的正确率
  def coverage
    self.ratio=1.0*self.correct/self.count
    return self.ratio
  end
end


class RealQuestion
=begin
  summary:本类是数据库中存取的Question转化而来的虚类
=end
  include MyException
  def jsonMap
    #返回存入数据库时实际的字典
  end

  def self.instance(info)
    if info[:options].is_a? Hash
      info[:options]=info[:options].sort{|k,v| k.to_i<=>v.to_i}
    end
    if info[:questionType]==Question::QuestionType[:single]
      return SingleQuestion(info)
    elsif info[:questionType]==Question::QuestionType[:selection]
      return SelectQuestion(info)
    elsif info[:questionType]==Question::QuestionType[:judge]
      return JudgeQuestion(info)
    else
      raise IllegalActionException,"请选择有效的题型"
    end
  end

end

class SelectQuestion < RealQuestion

  # 从哈希构造实体
  def initialize(info)
    @description=info[:descrption]
    @options=info[:options]
    @score=info[:score]
    @reference=info[:reference]
    @questionType=info[:questionType]
    @id=info[:id]
  end

  def jsonMap
    return {
        description: @description,
        options: ActiveSupport::JSON.encode(@options),
        score:@score,
        reference:@reference,
        questionType:Question::QuestionType[:selection]
    }
  end

end

class JudgeQuestion < RealQuestion
  # 从哈希构造实体
  def initialize(info)
    @description=info[:descrption]
    @score=info[:score]
    @reference=info[:reference]
    @questionType=info[:questionType]
    @id=info[:id]
  end

  def jsonMap
    return {
        description: @description,
        score:@score,
        reference:@reference,
        questionType:Question::QuestionType[:judge]
    }
  end
end

class SingleQuestion < RealQuestion
  # 从哈希构造实体
  def initialize(info)
    @description=info[:descrption]
    @score=info[:score]
    @options=info[:options]
    @reference=info[:reference]
    @questionType=Question::QuestionType[:single]
    @id=info[:id]
  end

  def jsonMap
    return {
        description: @description,
        score:@score,
        options: ActiveSupport::JSON.encode(@options),
        reference:@reference,
        questionType:Question::QuestionType[:single]
    }
  end
end