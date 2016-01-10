class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps
      t.string :account
      t.string :password
      t.string :email
      t.string :name
      t.integer :userType
      t.belongs_to :student
      t.belongs_to :teacher
      t.string :avatar
      t.boolean :verified
    end
  end
end
