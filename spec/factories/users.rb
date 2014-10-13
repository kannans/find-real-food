FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "user+#{n}@example.com" }
    f.password "test1234567"
    f.password_confirmation "test1234567"
  end
end
