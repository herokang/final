class Quiz < ActiveRecord::Migration
  def change
    create_table :quizs do |t|
      t.datetime :lastModified
      t.integer :status
    end
  end
end
