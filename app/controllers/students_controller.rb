class StudentsController < ApplicationController

  def studentParams

  end

  def userParams

  end

  def show
    @student=Student.find(params[:id])
  end

  def edit
    @student=Student.find(params[:id])
  end

  def update
    @student=Student.find(params[:id])
  end

  def destroy
  end
end
