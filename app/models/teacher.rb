class Teacher < ActiveRecord::Base
  has_many :lessons
  has_one :user, autosave: true
  after_initialize :init
  def init
    self.binded ||=false
  end
end
