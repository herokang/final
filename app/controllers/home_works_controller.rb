require_relative '../utils/my_exception'

class HomeWorksController < ApplicationController
  include MyException
  before_action :check_permission, :except => [:list]
  before_action :check_list, :only => [:list]

  rescue_from UnAuthorizedException do |ex|
    flash[:notice] = "请先登录"
    redirect_to login_path
  end

  rescue_from IllegalActionException do |ex|
    flash[:notice] = ex.message
  end

  def check_list
    raise UnAuthorizedException if session[:teacherId].nil? and session[:studentId].nil?
    if not session[:teacherId] and not params[:quizId].nil?
      quiz=Quiz.find(params[:quizId])
      raise IllegalActionException,"无权查看该作业列表" if quiz.lesson.teacher_id!=session[:teacherId]
    end
  end

  def check_permission
    @homeWork=HomeWork.find(params[:id])
    if not session[:studentId]
      raise IllegalActionException,"无权操作此作业" if @homeWork.student_id!=session[:studentId]
    elsif not session[:teacherId]
      quiz=Quiz.find(@homeWork.quizId)
      raise IllegalActionException,"无权操作此作业" if quiz.lesson.teacher_id!=session[:teacherId]
    else
      raise UnAuthorizedException
    end
  end

  def homeWorkParams
    params.permit([:answers,:interval])
  end

  # @summary: 对于教师用户返回特定问卷的所有已提交作业,对于学生返回特定课程下的所有作业
  def list
    if not session[:teacherId].nil?
      if params[:quizId].nil?
      else
        @homeWorks=HomeWork.where(quizId:params[:quizId],status:HomeWork::STATUS[:commited])
      end
    elsif not session[:studentId].nil?
      if params[:lessonId].nil?
        #返回学生所有的作业
        @homeWorks=Student.find(session[:studentId]).home_works
      else
        quizIds=Lesson.find(params[:lessonId]).quizs.map{|q| q.id}
        @homeWorks=HomeWork.where(quizId:quizIds,student_id:session[:studentId])
      end
    end
  end

  # @summary: 展示某份作业的报告
  def show
    # @homeWork=HomeWork.find(params[:id])
  end

  # @summary: 向学生展示要做的特定作业
  def edit
    # @homeWork=HomeWork.find(params[:id])
  end

  def update
    # @homeWork=HomeWork.find(params[:id])
    raise IllegalActionException,"不得更改已提交的作业" if @homeWork.status==HomeWork::STATUS[:commited]
    info=homeWorkParams
    if not info[:answers].nil?
      raise IllegalActionException,"非法的请求参数" if not info[:answers].is_a? Array
      raise IllegalActionException,"非法的请求参数" if info[:answers].size != @homeWork.answers.length
      for i in (0..@homeWork.answers.length)
        @homeWork.answers[i].record=info[:answers][i]
      end
    end
    @homeWork.interval=info[:interval] if not info[:interval.nil?] and info[:interval]<@homeWork.interval
    # TODO 返回修改成功
  end

  # @summay: 学生提交作业,后台自动评分
  def commit
    # @homeWork=HomeWork.find(params[:id])
    raise IllegalActionException,"不得提交已提交的作业" if @homeWork.status==HomeWork::STATUS[:commited]
    if not params[:answers].nil?
      raise IllegalActionException,"非法的请求参数" if not params[:answers].is_a? Array
      raise IllegalActionException,"非法的请求参数" if params[:answers].size != @homeWork.answers.length
      for i in (0..@homeWork.answers.length)
        @homeWork.answers[i].record=params[:answers][i]
      end
    end
    @homeWork.status=HomeWork::STATUS[:commited]
    @homeWork.interval=0
    @homeWork.comment()
    @homeWork.save()
    # TODO 返回提交成功
  end
end