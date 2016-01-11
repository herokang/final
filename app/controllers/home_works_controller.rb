class HomeWorksController < ApplicationController
  def list
  end

  def show
  end

  def edit
  end

  def update
  end

  def commit


    #发送提交确认邮件
    HomeworkNotifier.commited(@homework).deliver
    
  end

end
