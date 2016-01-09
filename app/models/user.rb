class User < ActiveRecord::Base
  belongs_to :student
  belongs_to :teacher
  UserType={:unknown=>0,:student=>1, :teacher=>2}
end
