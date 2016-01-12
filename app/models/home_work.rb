class HomeWork < ActiveRecord::Base
  has_many :answers, autosave: true, dependent: :destroy
  belongs_to :student, dependent: :delete, autosave: false
  STATUS={:uncommited=>0,:commited=>1,:commented=>2}
  after_initialize :init
  def init
    self.status ||=STATUS[:uncommited]
    self.interval=600 #默认作业剩下的时间为10分钟
  end

  # @summary: 为作业评分
  def comment()

  end
end
