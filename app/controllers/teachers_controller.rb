require_relative '../utils/my_exception'
class TeachersController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  include MyException
  before_action :check_login, :except => [:show]
  rescue_from UnAuthorizedException do |ex|
    flash[:notice] = "请先登录对应身份的账户"
    redirect_to "/index/login"
  end

  rescue_from IllegalActionException do |ex|
    flash[:notice] = ex.message
    redirect_to teacher_path(@teacher)
  end

  def check_login
    raise UnAuthorizedException,"教师账户未登录" if session[:teacherId].nil?
  end

  def teacherParams
    params.permit(:teacherNo)
  end

  def userParams
    params.permit(:name, :avatar)
  end

  def show
    @teacher=Teacher.find(params[:id])
  end

  def edit
    @teacher=Teacher.find(session[:teacherId])
  end

  def update
    @teacher=Teacher.find(session[:teacherId])
    info=teacherParams()
    if not info[:studentNo].nil? and Teacher.where(teacherNo: info[:teacherNo]).exists?
      raise IllegalActionException, "绑定工号失败"
    end
    @teacher.update_attributes!(info)
    @teacher.user.update_attributes!(userParams)
    redirect_to teachers_update_path(@teacher)
  end



  def destroy
    @teacher=Student.find(session[:teacherId])
    @teacher.destroy
    flash[:notice] = "Teacher '#{@teacher.teacherNo}' deleted."
    redirect_to teachers_path
  end

  # @summary: 返回教师所开课程
  def lessons
    @teacher=Teacher.find(session[:teacherId])
    @lessons=@teacher.lessons
    redirect_to lessons_path
  end

end
