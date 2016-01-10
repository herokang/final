require 'digest/md5'

class Student < ActiveRecord::Base
  has_many :lessons, through: :assignments, autosave: false
  has_many :home_works, dependent: destroy, autosave: false
  has_one :user,autosave: true, dependent: destroy
  after_initialize :init
  def init
    self.binded ||=false
  end

  def self.profile(id, pwd)
    ret = []
    @profile = Student.find(id)
    if @profile == nil || @profile.empty?
      ret[0] = 'the user not exist'
      ret[1] = -1
      return ret
    else
      pwd = Digest::SHA1.hexdigest(pwd)
      if @profile.pwd == pwd
        ret[0] = 'login success'
        ret[1] = 0
        return true
      else
        ret[0] = 'the password is not correct'
        ret[1] = -1
        return false
      end
    end


  end
end
