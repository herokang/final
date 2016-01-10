class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :lessonNo
      t.integer :limit
      t.integer :status
      t.belongs_to :teacher
      t.timestamps
    end
  end
end
