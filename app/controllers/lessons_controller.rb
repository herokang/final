require_relative '../utils/my_exception'


class LessonsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  include MyException
  before_action :check_login, :except => [:show,:index,:new]
  before_action :check_permission, :only => [:edit,:update,:destroy]
  rescue_from UnAuthorizedException do |ex|
    flash[:notice] = "课程操作必须要求老师帐号"
    redirect_to "index/login"
  end

  rescue_from IllegalActionException do |ex|
    flash[:notice] = ex.message
    redirect_to teacher_path(@teacher)
  end

  def check_login
    raise UnAuthorizedException if session[:teacherId].nil?
  end

  def check_permission
    @lesson=Lesson.find(params[:id])
    raise IllegalActionException,"不是本课程的教师" if session[:teacherId]!= @lesson.teacher_id
  end

  def lesson_params
    params.require(:lesson).permit(:name, :description,:credit,:semester)
  end

  def index
    @lessons = Lesson.all
    # 对于登录的学生用户,标记他对于某门课的状态
    for lesson in @lessons
      lesson.isAttend=false
    end

    if not session[:studentId].nil?
      @student=Student.find(session[:studentId])
      for lesson in @student.lessons
        lesson.isAttend=true
      end
    end

  end

  def show
    @lesson = Lesson.find(params[:id])
  end

  def new
    @lesson=Lesson.new
  end

  def create
    teacher=Teacher.find(session[:teacherId])
    @lesson = teacher.lessons.create!(lesson_params)
    flash[:notice] = "课程《#{@lesson.name}》创建成功！"
    redirect_to lessons_path
  end

  def edit
    @lesson = Lesson.find params[:id]
  end

  def update
    @lesson = Lesson.find params[:id]
    @lesson.update_attributes!(lesson_params)
    flash[:notice] = "课程《#{@lesson.name}》更新成功！"
    redirect_to lessons_path
  end

  def destroy
    @lesson = Lesson.find params[:id]
    @lesson.destroy
    flash[:notice] = "课程《#{@lesson.name}》删除成功！"
    redirect_to lessons_path
  end
end
