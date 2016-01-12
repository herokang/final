class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :description
      t.text :options
      t.string :reference
      t.integer :score
      t.integer :questionType
      t.belongs_to :quiz
      t.float :ratio #该问题的正确率
      t.integer :count #目前提交该题的人数
      t.integer :correct #做对的人数
      t.timestamps
    end
  end
end
