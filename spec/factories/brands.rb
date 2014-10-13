# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brand do
    name "MyString"
    phone "MyString"
    website "MyString"
    order_by_phone false
    order_by_online false
    third_party_available false
  end
end
