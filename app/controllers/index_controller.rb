# 主管首页展示和用户登录,用户注册属于用户创建,应该在UsersController中调用create完成

class IndexController < ApplicationController
  def index
  end

  def login
    @user=User.find_by(account: params[:account], password: params[:password])
    if @user.nil?
      flash[:notice] = "用户名密码错误!"
      redirect_to users_path
    end
    case @user.userType
      when User::UserType[:student]
        session[:studentId]=@user.student.id
      when User::UserType[:teacher]
        session[:teacherId]=@user.teacher.id
    end
    flash[:notice] = "登录成功!"
    redirect_to user_path(@user)
  end
end
