FactoryBot.define do

  factory :role do

  end

  factory :party do
    
  end

  factory :agreement do
    
  end

  factory :dashboarddatum do
    
  end

  factory :message do
    body { "MyText" }
  end

  factory :jwt_blacklist do
    jti { "MyString" }
    exp { "2023-07-14 13:42:43" }
  end

  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { generate(:email) }
    password { Faker::Internet.password(min_length: 8) }
  end
end