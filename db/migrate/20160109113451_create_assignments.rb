class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :student
      t.belongs_to :lesson
      t.timestamps
    end
  end
end
