# 主管首页展示和用户登录,用户注册属于用户创建,应该在UsersController中调用create完成

class IndexController < ApplicationController
  def index
    render 'index/login'
  end

  def login
  end

  def userlogin
    render 'index/login'
  end

  def register
  end

  #以下方法和页面为静态页面，后期填数据时再往相关的views里面套
  def tmpTeacherIndex

  end

  def StudentCourse

  end

  def Studenthomework

  end

  def Studenthomeworkonline

  end
end
