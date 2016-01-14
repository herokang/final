class HomeWork < ActiveRecord::Base
  has_many :answers, autosave: true, dependent: :destroy
  belongs_to :student, dependent: :delete, autosave: false
  STATUS={:uncommited=>0,:commited=>1,:commented=>2}
  after_initialize :init
  def init
    self.status ||=STATUS[:uncommited]
    self.interval=600 #默认作业剩下的时间为10分钟
    self.start ||=nil
  end

  # @summary: 为作业评分,同时为对应的作业题增加统计量
  def compute()
    sum=0
    answers=Answer.where(home_work_id: self.id)
    for answer in answers
      question=answer.question
      question.count+=1
      if answer.discriminate
        question.correct+=1
        sum+=answer.score
      end
      question.save!
      # answer.save!
    end
    self.grade=sum
    return sum
  end

  def quiz
    return Quiz.find(self.quizId)
  end
end
