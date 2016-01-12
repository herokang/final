class Quiz < ActiveRecord::Migration
  def change
    create_table :quizs do |t|
      t.datetime :lastModified
      t.integer :status
      t.belongs_to :lesson
      t.integer :limitTime #作业的限时时间
      t.integer :number #最终给学生发布的题数
      t.string :title
      t.text :demand
      t.integer :highest #最高分
      t.integer :lowest  #最低分
      t.float :average   #平均分
    end
  end
end
