require_relative '../utils/my_exception'
class QuizsController < ApplicationController
  include MyException
  before_action :check_login, :except => [:new]
  before_action :check_permission, :only => [:edit,:update,:destroy, :show, :publish]
  rescue_from UnAuthorizedException do |ex|
    flash[:notice] = "问卷操作必须要求老师帐号"
    redirect_to login_path
  end

  rescue_from IllegalActionException do |ex|
    flash[:notice] = ex.message
    redirect_to teacher_path(@teacher)
  end

  def check_login
    raise UnAuthorizedException if session[:teacherId].nil?
  end

  def check_permission
    @quiz=Quiz.find(params[:id])
    raise IllegalActionException,"请选择有效的问卷进行操作" if @quiz.nil?
    raise IllegalActionException,"不是本问卷的所有者" if session[:teacherId]!=@quiz.lesson.teacher_id
  end

  # @summary 返回登录教师在某课程下布置的所有问卷
  def index
    if params[:lessonId].nil?
      teacher=Teacher.find(session[:teacherId])
      lessonIds=teacher.lessons.map{|l| l.id}
      @quizs=Quiz.where(lesson_id :lessonIds )
    else
      lesson=Lesson.find(params[:lessonId])
      raise IllegalActionException,"不是本问卷的所有者" if lesson.teacher_id!=session[:teacherId]
      @quizs=lesson.quizs
    end
  end

  # @summary: 返回登录教师创建的特定问卷
  def show
    @quiz=Quiz.find(params[:id])
    @quiz.generate()
  end

  # @summary: 创建新问卷
  def create
  end

  def edit
    @quiz=Quiz.find(params[:id])
    @quiz.generate()
  end


  def update
  end

  # @summary: 通过老师上传的文件生成作业内容
  def upload

  end

  def destroy
    @quiz=Quiz.find(params[:id])
    if @quiz.status==Quiz::STATUS[:unassigned]
      @quiz.destroy!
      # homeworks=HomeWork.where(quizId:@quiz.id)
      # homeworks.destroy_all
    else
      raise IllegalActionException,"已发布的作业不允许删除"
    end
  end

  # @summary: 发布作业给学生,系统会为每位选课的学生自动生成一份Homework
  def publish

  end

end
