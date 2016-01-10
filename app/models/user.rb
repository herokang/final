class User < ActiveRecord::Base
  belongs_to :student,dependent: destroy,autosave: false
  belongs_to :teacher,dependent: destroy,autosave: false
  UserType={:unknown=>0,:student=>1, :teacher=>2}
  after_initialize :init

  def init
    self.userType ||=UserType[:unknown]
    self.verified ||=false
  end
end
