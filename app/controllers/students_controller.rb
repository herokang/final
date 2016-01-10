require 'utils/my_exception'

class StudentsController < ApplicationController
  before_action :check_login, :except => [:show]
  rescue_from UnAuthorizedException do |ex|
    flash[:notice] = ex.message
    redirect_to students_path
  end

  rescue_from IllegalActionException do |ex|
    flash[:notice] = "非法的操作"
    redirect_to student_path(@student)
  end


  def studentParams
    params.permit(:studentNo)
  end

  def userParams
    params.require(:user).permit(:name, :avatar)
  end

  def show
    @student=Student.find(params[:id])
  end

  def edit
    @student=Student.find(session[:studentId])
  end

  def update
    @student=Student.find(session[:studentId])
    info=studentParams()
    if not info[:studentNo].nil? and Student.where(studentNo: info[:studentNo]).exists?
      raise IllegalActionException, "绑定学号失败"
    end
    @student.update_attributes!(info)
    @student.user.update_attributes!(userParams)
    redirect_to student_path(@student)
  end

  def destroy
    @student=Student.find(session[:studentId])
    @student.destroy
    flash[:notice] = "Student '#{@student.studentNo}' deleted."
    redirect_to students_path
  end

  # @summary: 学生选课
  def attend
    @student=Student.find(session[:studentId])
    lessonIds=params[:lessonIds]
    for lessonId in lessonIds do
      lesson=Lesson.find(lessonId)
      if not lesson.nil?
      #if not lesson.nil? and lesson.status==Lesson::STATUS[:attenable] and lesson.students.size < lesson.limit
        @student.lessons<<lesson
      end

    end
    @student.save

    # TODO 增加页面返回代码
  end

  # @summary: 学生退课
  def exit
    assignment=Assignment.where(student_id :session[:studentId],lesson_id:params[:lessonId]).take!
    assignment.delete

  end



  def check_login
    raise UnAuthorizedException,"学生账户未登录" if session[:studentId].nil?
  end

end
