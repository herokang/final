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
    @quiz = Quiz.find(params[:id])
    if @quiz.status==Quiz::STATUS[:unassigned]
      questions = @quiz.questions
      question_num = questions.size
      @pub_questions = Array.new   #发布的一份问卷上的题
      if question_num>= 20         #假设问卷上出20题
        range = (0..question_num-1).to_a
        array = range.sample(20)   #随机选择20题
        array.each {|q|  @pub_questions.push(questions.find(q))}
      else
        raise IllegalActionException,"题库中题量过少，无法生成问卷"
      end
    else 
      raise IllegalActionException,"已发布的作业不允许重复发布"
    end
  end

  # @summary: 生成作业情况统计报告
  def report
    @quizId = params[:id]
    hw_commited = HomeWork.where( :quizId => @quizId, :status => HomeWork::STATUS[:commited])
    hw_commented = HomeWork.where( :quizId => @quizId, :status => HomeWork::STATUS[:commented])
    if not ( hw_commited.nil? or hw_commented.nil?)
      @hw_num = hw_commited.count + hw_commented.count
      if not hw_commented.nil?
        @hw_high = hw_commented.maximum(:grade)
        @hw_low = hw_commented.minimum(:grade)
        @hw_ave = hw_commented.average(:grade)
      end
      #每道题的正确率还没写
    end
   end

end
