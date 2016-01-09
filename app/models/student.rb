require 'digest/md5'

class Student < ActiveRecord::Base
  has_many :home_works
  has_and_belongs_to_many :lessons
  has_one :user

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
