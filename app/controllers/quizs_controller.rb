require 'utils/my_exception'

class QuizsController < ApplicationController
  before_action :check_login, :except => [:new]
  before_action :check_permission, :only => [:edit,:update,:destroy,:index, :show]
  rescue_from UnAuthorizedException do |ex|
    flash[:notice] = "问卷操作必须要求老师帐号"
    redirect_to quizs_path
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
  end

  # @summary: 返回登录教师创建的特定问卷
  def show
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
