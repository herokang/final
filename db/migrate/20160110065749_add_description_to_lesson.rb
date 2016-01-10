class AddDescriptionToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :descrption, :text
  end
end
