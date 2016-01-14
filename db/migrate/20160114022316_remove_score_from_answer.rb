class RemoveScoreFromAnswer < ActiveRecord::Migration
  def change
    remove_column :answers,:score
    add_column :answers, :weight, :integer
  end
end
