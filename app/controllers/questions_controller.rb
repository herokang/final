require_relative '../utils/my_exception'

class QuestionsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  include MyException
  before_action :check_login
  before_action :check_permission, :only => [:update, :destroy]
  rescue_from UnAuthorizedException do |ex|
    flash[:notice] = "问卷操作必须要求老师帐号"
    redirect_to "/index/login"
  end

  rescue_from IllegalActionException do |ex|
    flash[:notice] = ex.message
    redirect_to questions_path
  end

  def questionParam
    params.permit([:description,:options,:score,:reference,:category])
  end

  def check_login
    raise UnAuthorizedException if session[:teacherId].nil?
    @teacher=Teacher.find(session[:teacherId])
  end

  def check_permission
    @question=Question.find(params[:id])
    quiz=Quiz.find(@question.quiz_id)
    raise IllIllegalActionException,"不是本问题的所有者" if session[:teacherId]!=quiz.lesson.teacher_id
  end


  def new
    @question=Question.new
  end

  def create
    raise IllIllegalActionException,"请先指定对应的作业!" if params[:quizId].nil?
    quiz=Quiz.find(params[:quizId])
    info=questionParam
    info[:questionType]= Question::QuestionType[:selection] if info[:questionType].nil?
    tmp=RealQuestion::instance(info)
    question=quiz.questions.create(tmp.jsonMap)# 向数据库写入问题
    if quiz.status == Quiz::STATUS[:assigned]
      # 当作业已经发布时,为每位同学增加该题
      for homework in HomeWork.where(quizId:quiz.id) do
        answer=homework.answers.build()
        answer.question=question
        answer.save()
      end
    end

    # TODO 返回前端创建成功
  end

  def update
    info=questionParam
    info[:questionType]= Question::QuestionType[:selection] if info[:questionType].nil?
    tmp=RealQuestion::instance(info)
    @question.update_attributes!(tmp.jsonMap)
  end

  def destroy
    @question.destroy
  end
end
