class CreateSelectQuestions < ActiveRecord::Migration
  def change
    create_table :select_questions do |t|
      t.Array :options
      t.Array :answers

      t.timestamps
    end
  end
end
