require_relative '../utils/my_exception'
require_relative '../helpers/quizs_helper'
class QuizsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  include MyException,QuestionsHelper
  before_action :check_login, :except => [:new]
  before_action :check_permission, :only => [:edit,:update,:destroy, :show, :publish,:upload]
  rescue_from UnAuthorizedException do |ex|
    flash[:notice] = "问卷操作必须要求老师帐号"
    redirect_to "/index/login"
  end

  rescue_from IllegalActionException do |ex|
    flash[:notice] = ex.message
    redirect_to "/index"
  end

  def check_login
    raise UnAuthorizedException if session[:teacherId].nil?
    @teacher=Teacher.find(session[:teacherId])
  end

  def check_permission
    raise IllegalActionException,"请至少选择一个问卷进行操作" if params[:id].nil?
    @quiz=Quiz.find(params[:id])
    raise IllegalActionException,"请选择有效的问卷进行操作" if @quiz.nil?
    raise IllegalActionException,"不是本问卷的所有者" if session[:teacherId]!=@quiz.lesson.teacher_id
  end

  def quiz_params
    params.permit([:title,:demand,:limitTime,:number])
  end

  def new
    @quiz=Quiz.new
  end

  # @summary 返回登录教师在某课程下布置的所有问卷
  def index
    @teacher=Teacher.find(session[:teacherId])
    if params[:lessonId].nil?
      # teacher=Teacher.find(session[:teacherId])
      lessonIds=@teacher.lessons.map{|l| l.id}
      @quizs=Quiz.where(lesson_id: lessonIds )
      render 'teachers/exercise'
    else
      @lesson=Lesson.find(params[:lessonId])
      raise IllegalActionException,"不是本问卷的所有者" if @lesson.teacher_id!=session[:teacherId]
      @quizs=@lesson.quizs
      render 'teachers/exercise_manage'
    end
  end

  # @summary: 返回登录教师创建的特定问卷
  def show
    # @quiz=Quiz.find(params[:id])
    @lesson=@quiz.lesson
    @questionList=@quiz.generate
    render "teachers/quizs"
  end

  # @summary: 创建新问卷
  def create
    raise IllegalActionException,"请指定创建问卷的课程" if params[:lessonId].nil?
    lesson=Lesson.find(params[:lessonId])
    @quiz=lesson.quizs.create!(quiz_params)
    if not params[:questionList].nil?
      ave_score=100/@quiz.number
      for tmp in params[:questionList]
        realQuestion=RealQuestion::instance(tmp)
        info=realQuestion.jsonMap
        info[:score]=ave_score
        question=@quiz.questions.create(info)
      end
      @quiz.save
    end
    redirect_to teachers_exercise_path+"?lessonId="+params[:lessonId]
  end

  def edit
    # @quiz=Quiz.find(params[:id])
    @questionList=@quiz.generate
  end


  def update
    @quiz.update_attributes!(quiz_params)
  end

  # @summary: 通过老师上传的文件生成作业内容
  # def upload
  #   raise IllegalActionException,"请提交有效文件" if params[:upload].nil? or not (params[:upload].is_a? StringIO or params[:upload].is_a? File)
  #   content=params[:upload].read
  #   questionList=parser(content)
  #   for tmp in questionList
  #     @quiz.questions.create!(tmp.jsonMap)
  #   end
  #   @quiz.save!
  #   # TODO 返回上传成功
  # end

  def destroy
    # @quiz=Quiz.find(params[:id])
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
    # @quiz = Quiz.find(params[:id])
    questions=@quiz.questions
    raise IllegalActionException,"已发布的作业不允许重复发布" if @quiz.status!=Quiz::STATUS[:unassigned]
    raise IllegalActionException,"发布的题数不应少于总题数" if @quiz.number > @quiz.questions.length
    # total=questions.length
    # score=100/@quiz.number  #每道题的分数
    # for student in @quiz.lesson.students
    #   # 这一部分还需斟酌,因为对于autosave的理解不很清楚,不知道homework存储时会不会新建它附带的answer
    #   # homework=student.home_works.create!({:interval=>@quiz.limitTime,:quizId=>@quiz.id})
    #   homework=student.home_works.create!({:interval=>@quiz.limitTime,:quizId=>@quiz.id,:title=>@quiz.title})
    #   range = (0..total-1).to_a
    #   candidate=range.sample(@quiz.number)
    #   for i in candidate
    #     answer=Answer.new
    #     answer.question_id=questions[i].id
    #     answer.homeWork_id=homework.id
    #     homework.answers<<answer
    #   end
    #   homework.save
    # end
    @quiz.status=Quiz::STATUS[:assigned]
    @quiz.save
    flash[:notice] = "发布成功"
    redirect_to teachers_quizs_path+"?id="+params[:id]
  end

  # @summary: 生成作业情况统计报告
  def report
    # 问卷为结束或未发布状态下没有
    if @quiz.status=Quiz::STATUS[:assigned]
      quizId=params[:id]
      @homeWorks=HomeWork.where("quizId = ? AND status > ?",quizId,HomeWork::STATUS[:uncommited])
      # homeWorks=HomeWork.where(quizId:quizId,status:HomeWork::STATUS[:commited])
      # homeWorks=homeWorks+HomeWork.where(quizId:quizId,status:HomeWork::STATUS[:commented])
      total=homeWorks.length
      @quiz.highest=homeWorks.maximum(:grade)
      @quiz.lowest=homeWorks.minimum(:grade)
      @quiz.average=homeWorks.average(:grade)
      for question in @quiz.questions
        question.coverage
        # question.save
      end
      # 此处同样是不知道设置的autosave会不会生效
      @quiz.save
    end
    @questionList=@quiz.generate

    # TODO 渲染报告
  end
end
