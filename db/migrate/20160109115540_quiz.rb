class Quiz < ActiveRecord::Migration
  def change
    create_table :quizs do |t|
      t.datetime :lastModified
      t.integer :status
      t.belongs_to :lesson
      t.integer :limitTime #作业的限时时间
      t.integer :number #最终给学生发布的题数
    end
  end
end
