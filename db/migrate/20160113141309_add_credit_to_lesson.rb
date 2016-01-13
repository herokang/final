class AddCreditToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :credit, :integer
    add_column :lessons, :semester, :string
  end
end
