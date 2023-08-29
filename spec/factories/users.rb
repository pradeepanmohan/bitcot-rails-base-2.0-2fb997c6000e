FactoryBot.define do
  password = Faker::Internet.password(min_length: 8)
  FactoryBot.define do
    sequence :email do |n|
      "testqa+#{'%03d' % (n)}@bitcot.com"
    end
  end
end
