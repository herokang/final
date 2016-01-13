class AddStartToHomeWork < ActiveRecord::Migration
  def change
    add_column :home_works, :start, :datetime
  end
end
