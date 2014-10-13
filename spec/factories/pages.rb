# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title "MyString"
    body "MyText"
    picture_file_name "MyString"
    picture_content_type "MyString"
    picture_file_size 1
    picture_updated_at "2014-09-30 17:25:25"
  end
end
