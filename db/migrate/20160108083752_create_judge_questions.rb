class CreateJudgeQuestions < ActiveRecord::Migration
  def change
    create_table :judge_questions do |t|
      t.boolean :answer

      t.timestamps
    end
  end
end
