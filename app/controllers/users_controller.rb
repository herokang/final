class UsersController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def update_params
    params.permit(:email,:name, :avatar)
  end

  def create_params
    params.permit([:account,:userType,:password,:verified,:email])
  end

  def new
    @user=User.new
  end

  def create
    userParam=create_params

    exist=User.where(account: userParam[:account]).take
    if not exist.nil?
      flash[:notice] = "重复的用户名!"
      redirect_to "/index/register"
    end
    exist=User.where(account: userParam[:account]).take
    if not exist.nil?
      flash[:notice] = "重复的邮箱!"
      redirect_to "/index/register"
    end

    userParam[:userType]=User::UserType[:student] if userParam[:userType]!=User::UserType[:teacher]
    puts userParam
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
    @user.update_attributes(update_params)


    if params.has_key(:newPassword) and userParam[:oldPassword]==@user.password
      @user.password=params[:newPassword]
      @user.save()
    end

    redirect_to user_path(@user)
  end



end
