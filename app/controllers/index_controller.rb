# 主管首页展示和用户登录,用户注册属于用户创建,应该在UsersController中调用create完成

class IndexController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def index
    if not session[:studentId].nil?
      @student=Student.find(session[:studentId])
      render ""
    elsif not session[:teacherId].nil?
      @teacher=Teacher.find(session[:teacherId])
      render ""
    else
      render "index/login"
    end
  end

  def login
    @user=User.find_by(account: params[:email], password: params[:password])
    if @user.nil?
      flash[:notice] = "用户名密码错误!"
      # TODO 登录失败
    end
    case @user.userType
      when User::UserType[:student]
        session[:studentId]=@user.student.id
      when User::UserType[:teacher]
        session[:teacherId]=@user.teacher.id
    end
    flash[:notice] = "登录成功!"
    redirect_to "index/index"

    # TODO 登录成功逻辑
  end

  def loginView
    puts "hehe"
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
