class AddTitleToQuiz < ActiveRecord::Migration
  def change
    add_column :quizs, :title, :string
    add_column :quizs, :demand, :text
  end
end
