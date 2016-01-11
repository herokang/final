require_relative '../utils/my_exception'

class ReportsController < ApplicationController
 #    include MyException
 #    before_action :check_login, :except => [:new]
 #    before_action :check_permission, :only => [:edit,:update,:destroy, :show]
 #    rescue_from UnAuthorizedException do |ex|
 #    	flash[:notice] = "查看报告必须要求老师帐号"
 #    	redirect_to quizs_path
 #    end	

	# rescue_from IllegalActionException do |ex|
	# flash[:notice] = ex.message
	# redirect_to teacher_path(@teacher)
	# end

	# def check_login
	# 	raise UnAuthorizedException if session[:teacherId].nil?
	# end

	# def check_permission
	# 	@quiz=Quiz.find(params[:quizId])
	# 	raise IllegalActionException,"请选择有效的问卷进行操作" if @quiz.nil?
	# 	raise IllegalActionException,"不是本问卷的所有者" if session[:teacherId]!=@quiz.lesson.teacher_id
	# end

    #作业情况统计报告
	def show
		# @quiz=Quiz.find(params[:quizId])
		@quizId = params[:quizId]
		hw_commited = HomeWork.where( :quizId => @quizId, :status => 1)
		hw_commented = HomeWork.where( :quizId => @quizId, :status => 2)
		if not ( hw_commited.nil? or hw_commented.nil?)
			@hw_num = hw_commited.count + hw_commented.count
			if not hw_commented.nil?
				@hw_high = hw_commented.maximum(:grade)
				@hw_low = hw_commented.minimum(:grade)
				@hw_ave = hw_commented.average(:grade)
			end
		end
   end
end
