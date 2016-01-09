class CreateHomeWorks < ActiveRecord::Migration
  def change
    create_table :home_works do |t|
      t.integer :grade
      t.datetime :lastModified
      t.integer :status
    end
  end
end
