FactoryGirl.define do
  factory :product do
    product_key "MyString"
    category nil
    brand nil
    name "MyString"
    quality_rating nil
    in_stores false
    available false
    not_available "MyString"
  end
end
