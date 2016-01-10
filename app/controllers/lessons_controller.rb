class LessonsController < ApplicationController
  def lesson_params
    params.require(:lesson).permit(:name, :description)
  end

  def index
    @lessons = Lesson.all
  end

  def show
    @lesson = Lesson.find params[:id]
  end

  def new
    @lesson=Lesson.new
  end

  def create
    @lesson = Lesson.create!(lesson_params)
    flash[:notice] = "课程《#{@lesson.name}》创建成功！"
    redirect_to lessons_path
  end

  def edit
    @lesson = Lesson.find params[:id]
  end

  def update
    @lesson = Lesson.find params[:id]
    @lesson.update_attributes!(lesson_params)
    flash[:notice] = "课程《#{@lesson.name}》更新成功！"
    redirect_to lessons_path
  end

  def destroy
    @lesson = Lesson.find params[:id]
    @lesson.destroy
    flash[:notice] = "课程《#{@lesson.name}》删除成功！"
    redirect_to lessons_path
  end
end
