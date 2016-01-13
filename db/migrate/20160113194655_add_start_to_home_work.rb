class AddStartToHomeWork < ActiveRecord::Migration
  def change
    add_column :home_works, :start, :datetime
    add_column :home_works, :title, :string
  end
end
