class RemoveWeightFromAnswer < ActiveRecord::Migration
  def change
    remove_column :answers, :weight
    add_column :answers ,:mweight, :integer
  end
end
