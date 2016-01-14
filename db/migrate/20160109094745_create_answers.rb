class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :record
      t.belongs_to :home_work
      t.belongs_to :question
      t.timestamps
    end
  end
end
