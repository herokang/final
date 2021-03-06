require_relative '../utils/my_exception'

class HomeWorksController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  include MyException
  before_action :check_permission, :except => [:list,:listQuiz,:generate]
  before_action :check_list, :only => [:list]

  rescue_from UnAuthorizedException do |ex|
    flash[:notice] = "请先登录"
    redirect_to "/index/login"
  end

  rescue_from IllegalActionException do |ex|
    flash[:notice] = ex.message
    redirect_to "/index"
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
    if not session[:studentId].nil?
      raise IllegalActionException,"无权操作此作业" if @homeWork.student_id!=session[:studentId]
      @student=Student.find(session[:studentId])
    elsif not session[:teacherId].nil?
      quiz=Quiz.find(@homeWork.quizId)
      raise IllegalActionException,"无权操作此作业" if quiz.lesson.teacher_id!=session[:teacherId]
      @teacher=Teacher.find(session[:teacherId])
    else
      raise UnAuthorizedException
    end
  end

  def home_work_params
    params.permit([:answers,:interval])
  end

  # @summary: 返回某学生特定课程下已发布的作业或所有相关已发布作业
  def listQuiz
    raise UnAuthorizedException if not session[:studentId]
    @student=Student.find(session[:studentId])
    if params[:lessonId].nil?
      lessonIds=@student.lessons.map{|l| l.id}
      # @quizs=Quiz.where("lesson_id IN ? AND status > ?",lessonIds,Quiz::STATUS[:unassigned])
      @quizs=Quiz.where(lesson_id: lessonIds,status: Quiz::STATUS[:assigned])
    else
      raise IllegalActionException,"不得查看未选课的作业" if not Assignment.where(:student_id=>@student.id,:lesson_id=>params[:lessonId].to_i).exists?
      @quizs=Quiz.where("lesson_id = ? AND status > ?",params[:lessonId],Quiz::STATUS[:unassigned])
    end
    if params[:issubmit]
      @homeWork=HomeWork.find(params[:id])
      flash[:notice] = "作业：《"+@homeWork.title+"》提交成功"
    end
    render 'students/homeworks'
  end

  # @sumary: 为学生生成一份作业
  def generate
    raise UnAuthorizedException if not session[:studentId]
    @student=Student.find(session[:studentId])
    raise IllegalActionException," 请至少指定一个问卷" if params[:quizId].nil?
    @quiz=Quiz.find(params[:quizId])
    raise IllegalActionException,"不能参与未选课的作业" if not Assignment.exists?(lesson_id:@quiz.lesson_id,student_id:@student.id)
    raise IllegalActionException,"不得重复生成作业" if HomeWork.exists?(quizId:@quiz.id,student_id:@student.id)

    questions=@quiz.questions


    total=questions.length
    perScore=100/@quiz.number  #每道题的分数
    @homework=@student.home_works.create({:interval=>@quiz.limitTime,:quizId=>@quiz.id,:title=>@quiz.title})
    range = (0..total-1).to_a
    candidate=range.sample(@quiz.number)
    for i in candidate
      answer=Answer.new
      # answer.question_id=questions[i].id
      answer.question_id=questions[i].id
      answer.score=perScore
      answer.home_work_id=@homework.id
      answer.save
      # @homework.answers<<answer
    end
    # @homework.save
    redirect_to students_questions_path+"?id="+@homework.id.to_s
  end

  # @summary: 对于教师用户返回特定问卷的所有已提交作业,对于学生返回特定课程下的所有作业
  def list
    if not session[:teacherId].nil?
      if params[:quizId].nil?
        lessons=Teacher.find(session[:teacherId]).lessons
        quizIds=[]
        for lesson in lessons
          quizIds+=lessons.quizs.map{|q| q.id}
        end
        @homeWorks=HomeWork.where("quizId = ? AND status > ?",params[:quizId],HomeWork::STATUS[:uncommited])
        # @homeWorks=HomeWork.where(quizId:params[:quizId],status:HomeWork::STATUS[:commited])
        # @homeWorks=@homeWorks+HomeWork.where(quizId:params[:quizId],status:HomeWork::STATUS[:commented])
      else
        @homeWorks=HomeWork.where("quizId = ? AND status > ?",params[:quizId],HomeWork::STATUS[:uncommited])
        # @homeWorks=HomeWork.where(quizId:params[:quizId],status:HomeWork::STATUS[:commited])
        # @homeWorks=@homeWorks+HomeWork.where(quizId:params[:quizId],status:HomeWork::STATUS[:commented])
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
    render 'students/homeworks'
  end

  # @summary: 展示某份作业的报告
  def show
    # @homeWork=HomeWork.find(params[:id])
    @quiz=@homeWork.quiz
    @questionList=@quiz.generate
  end

  # @summary: 向学生展示要做的特定作业
  def edit
    # @homeWork=HomeWork.find(params[:id])
    @quiz=@homeWork.quiz
    @questionList=[]
    for answer in @homeWork.answers
      @questionList<<answer.question.transfer()
    end
    # @questionList=@quiz.generate
    @homeWork.start=Time.now if @homeWork.start.nil?
    @homeWork.save
    render 'students/questions'
  end

  def update
    # @homeWork=HomeWork.find(params[:id])
    raise IllegalActionException,"不得更改已提交的作业" if @homeWork.status!=HomeWork::STATUS[:uncommited]
    info=home_work_params
    current=Time.now
    if (current-@homeWork.start).second>@homeWork.interval+30
      flash[:notice]="同学,已到达交卷时间,请提交作业"
      redirect_to home_work_edit_path
      # @homeWork.status=HomeWork::STATUS[:commited]
    elsif not info[:answers].nil?
      raise IllegalActionException,"非法的请求参数" if not info[:answers].is_a? Array
      raise IllegalActionException,"非法的请求参数" if info[:answers].size != @homeWork.answers.length
      for i in (0..@homeWork.answers.length)
        @homeWork.answers[i].solution=info[:answers][i]
      end
    end
    # @homeWork.interval=info[:interval] if not info[:interval.nil?] and info[:interval]<@homeWork.interval
    @homeWork.save!

    flash[:notice] = "作业：《"+@homeWork.title+"》提交成功"
    redirect_to students_homeworks_path
  end

  # @summay: 学生提交作业,后台自动评分
  def commit
    # @homeWork=HomeWork.find(params[:id])
    raise IllegalActionException,"不得提交已提交的作业" if @homeWork.status!=HomeWork::STATUS[:uncommited]
    if not params[:answers].nil?
      @answers=Answer.where(home_work_id: @homeWork.id)
      raise IllegalActionException,"非法的请求参数" if not params[:answers].is_a? Array
       puts @answers.length
      # raise IllegalActionException,"非法的请求参数" if params[:answers].length != @homeWork.answers.length
      for i in (0..@answers.length-1)
        answer=@answers[i]
        answer.solution=params[:answers][i]
        answer.save
      end
    end
    @homeWork.status=HomeWork::STATUS[:commited]
    # @homeWork.interval=0
    @homeWork.compute()
    @homeWork.save()
  end

  # @summary: 教师为该作业写评语
  def comment
    raise IllegalActionException,"未提交的作业不得写评语" if @homeWork.status=HomeWork::STATUS[:uncommited]
    @homeWork.comment=params[:comment]
    @homeWork.status=HomeWork::STATUS[:commented]
    @homeWork.save
  end

end
