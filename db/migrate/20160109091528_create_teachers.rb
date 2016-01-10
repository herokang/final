class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :teacherNo
      t.boolean :binded
      t.timestamps
    end
  end
end
