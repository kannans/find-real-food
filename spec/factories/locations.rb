# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name "MyString"
    address "MyString"
    city "MyString"
    state nil
    zip "MyString"
    phone "MyString"
    website "MyString"
    hours "MyString"
  end
end
