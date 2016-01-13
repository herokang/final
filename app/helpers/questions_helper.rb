module QuestionsHelper
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
        info[:options]=info[:options].sort{|a,b| a[0].to_i<=>b[0].to_i}
        info[:options]=info[:options].map{|x| x[1]}
      end

      info[:questionType]= info[:questionType].to_i
      if info[:questionType]==Question::QuestionType[:single]
        return SingleQuestion.new(info)
      elsif info[:questionType]==Question::QuestionType[:selection]
        return SelectQuestion.new(info)
      elsif info[:questionType]==Question::QuestionType[:judge]
        return JudgeQuestion.new(info)
      else
        raise IllegalActionException,"请选择有效的题型"
      end
    end

  end

  class SelectQuestion < RealQuestion

    # 从哈希构造实体
    def initialize(info)
      @description=info[:description]
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
      @description=info[:description]
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
      @description=info[:description]
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
end
