class AddReportToQuiz < ActiveRecord::Migration
  def change
    add_column :quizs, :highest, :integer
    add_column :quizs, :lowest, :integer
    add_column :quizs, :average, :float
    add_column :questions, :count, :integer
    add_column :questions, :correct, :integer
  end
end
