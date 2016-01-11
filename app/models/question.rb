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

  def jsonMap
    #返回存入数据库时实际的字典
  end

end

class SelectQuestion < RealQuestion

  # 从哈希构造实体
  def initialize(info)

  end

  def jsonMap

  end

end

class JudgeQuestion < RealQuestion
  # 从哈希构造实体
  def initialize(info)

  end

  def jsonMap

  end
end