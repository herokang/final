# 主管首页展示和用户登录,用户注册属于用户创建,应该在UsersController中调用create完成

class IndexController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def index
    if not session[:studentId].nil?
      @student=Student.find(session[:studentId])
      render "students/index"
    elsif not session[:teacherId].nil?
      @teacher=Teacher.find(session[:teacherId])
      render "teachers/index"
    else
      # flash[:notice] = '请登录'
      render "index/login"
    end
  end

  def login
    @user=User.find_by(email: params[:email], password: params[:password])
    if @user.nil?
      flash[:notice] = "用户名密码错误!"
      redirect_to "/index/login"
      return
    end
    case @user.userType
      when User::UserType[:student]
        session[:studentId]=@user.student.id
      when User::UserType[:teacher]
        session[:teacherId]=@user.teacher.id
    end
    flash[:notice] = "登录成功!"
    redirect_to "/index"

    # TODO 登录成功逻辑
  end

  def logout
    if session[:studentId].nil? and session[:teacherId].nil?
      flash[:notice]="请先登录再注销"
    end
    session[:studentId]=nil
    session[:teacherId]=nil
    flash[:notice]="登出成功"
    redirect_to "/index"
  end

  def loginView
    puts "hehe"
    render 'index/login'
  end

  def register
  end

  #以下方法和页面为静态页面，后期填数据时再往相关的views里面套
  def tmpTeacherIndex
    render 'students/alllessons'
  end

  def StudentCourse
    render 'students/index'
  end

  def Studenthomework

  end

  def Studenthomeworkonline

  end
end
