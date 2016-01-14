class RemoveRecordFromAnswer < ActiveRecord::Migration
  def change
    remove_column :answers,:record
    remove_column :answers,:mweight
    add_column :answers, :score, :integer
    add_column :answers, :solution, :string
  end
end
