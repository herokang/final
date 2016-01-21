FactoryGirl.define do
  factory :user do
    sequence(:email) { Faker::Internet.email }
    sequence(:name) { Faker::Name.name }
    password 'complex_password'
  end

end