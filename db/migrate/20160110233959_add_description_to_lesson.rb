class AddDescriptionToLesson < ActiveRecord::Migration
  def change
    remove_column :lessons, :descrption
    add_column :lessons, :description, :text
  end
end
