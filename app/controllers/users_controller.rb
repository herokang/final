class UsersController < ApplicationController

  def user_params
    params.require(:user).permit(:email,:name, :avatar)
  end

  def create
    userParam=params[:user]

    if userParam[:password]!= userParam[:repeatPassword]
      flash[:notice] = "两次输入的密码不一致!"
      redirect_to users_path
    end

    exist=User.find_by(accout: userParam[:account])
    if not exist.nil?
      flash[:notice] = "重复的用户名!"
      redirect_to users_path
    end
    exist=User.find_by(email: userParam[:email]) if exist.nil?
    if not exist.nil?
      flash[:notice] = "重复的邮箱!"
      redirect_to users_path
    end

    userParam[:userType]=User::UserType[:student] if userParam[:userType]!=User::UserType[:teacher]
    @user=User.create!(userParam)
    case userParam[:userType]
      when User::UserType[:student]
        @user.create_student!()
      when User::UserType[:teacher]
        @user.create_teacher!()
    end

    flash[:notice] = "用户创建成功!"
  end

  def destroy
    @user=User.find(params[:id])
    @user.destroy
    flash[:notice] = "User '#{@user.account}' deleted."
    redirect_to users_path
  end

  def show
    id = params[:id]
    @user=User.find(id)
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    @user.update_attributes!(user_params)
    userParam=params[:user]

    if userParam.has_key(:newPassword) and userParam[:oldPassword]==@user.password
      @user.password=userParam[:newPassword]
    end
    @user.save()
    redirect_to user_path(@user)
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