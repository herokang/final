class Student < ActiveRecord::Base
  has_many :lessons, through: :assignments, autosave: false
  has_many :home_works, dependent: destroy, autosave: false
  has_one :user,autosave: true, dependent: destroy
  after_initialize :init
  def init
    self.binded ||=false
  end
end
