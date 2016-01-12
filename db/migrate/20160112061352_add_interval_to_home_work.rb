class AddIntervalToHomeWork < ActiveRecord::Migration
  def change
    add_column :home_works, :interval, :integer
    add_column :quizs, :limitTime, :integer
    add_column :answers ,:right, :boolean
    add_column :home_works, :comment, :text
    add_column :questions, :ratio, :float
    add_column :quizs, :number, :integer
  end
end
