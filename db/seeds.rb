State.create([
  { :name => 'Alabama'},
  { :name => 'Alaska'},
  { :name => 'Arizona'},
  { :name => 'Arkansas'},
  { :name => 'California'},
  { :name => 'Colorado'},
  { :name => 'Connecticut'},
  { :name => 'Delaware'},
  { :name => 'District of Columbia'},
  { :name => 'Florida'},
  { :name => 'Georgia'},
  { :name => 'Hawaii'},
  { :name => 'Idaho'},
  { :name => 'Illinois'},
  { :name => 'Indiana'},
  { :name => 'Iowa'},
  { :name => 'Kansas'},
  { :name => 'Kentucky'},
  { :name => 'Louisiana'},
  { :name => 'Maine'},
  { :name => 'Maryland'},
  { :name => 'Massachusetts'},
  { :name => 'Michigan'},
  { :name => 'Minnesota'},
  { :name => 'Mississippi'},
  { :name => 'Missouri'},
  { :name => 'Montana'},
  { :name => 'Nebraska'},
  { :name => 'Nevada'},
  { :name => 'New Hampshire'},
  { :name => 'New Jersey'},
  { :name => 'New Mexico'},
  { :name => 'New York'},
  { :name => 'North Carolina'},
  { :name => 'North Dakota'},
  { :name => 'Ohio'},
  { :name => 'Oklahoma'},
  { :name => 'Oregon'},
  { :name => 'Pennsylvania'},
  { :name => 'Rhode Island'},
  { :name => 'South Carolina'},
  { :name => 'South Dakota'},
  { :name => 'Tennessee'},
  { :name => 'Texas'},
  { :name => 'Utah'},
  { :name => 'Vermont'},
  { :name => 'Virginia'},
  { :name => 'Washington'},
  { :name => 'West Virginia'},
  { :name => 'Wisconsin'},
  { :name => 'Wyoming'}
])

Category.create!([
  { :title => 'Beverages', :sort => 26 },
  { :title => 'Bread', :sort => 19 },
  { :title => 'Butter & Ghee', :sort => 3 },
  { :title => 'Bacon, Ham & Sausage', :sort => 11 },
  { :title => 'Aged Cheese', :sort => 4 },
  { :title => 'Fresh Cheese', :sort => 5 },
  { :title => 'Coconut', :sort => 21 },
  { :title => 'Fish Oils', :sort => 16 },
  { :title => 'Condiments', :sort => 24 },
  { :title => 'Cookies, Bars & Muffins', :sort => 29 },
  { :title => 'Crackers', :sort => 30 },
  { :title => 'Cream', :sort => 2 },
  { :title => 'Eggs', :sort => 13 },
  { :title => 'Fats & Oils', :sort => 22 },
  { :title => 'Flour & Baking Supplies', :sort => 20 },
  { :title => 'Fruits & Vegetables', :sort => 8 },
  { :title => 'Grains & Legumes', :sort => 9},
  { :title => 'Ice Cream', :sort => 7  },
  { :title => 'Lacto-fermentation Starters', :sort => 18 },
  { :title => 'Lacto-fermented Vegetables', :sort => 17 },
  { :title => 'Fresh Meat', :sort => 10 },
  { :title => 'Processed Meat' },
  { :title => 'Milk', :sort => 1 },
  { :title => 'Nuts & Seeds', :sort => 15 },
  { :title => 'Pemmican & Jerky', :sort => 14 },
  { :title => 'Salt & Spices', :sort => 25 },
  { :title => 'Seafood', :sort => 12 },
  { :title => 'Snack Foods', :sort => 28 },
  { :title => 'Soups & Stocks', :sort => 23 },
  { :title => 'Sweeteners', :sort => 27 },
  { :title => 'Yogurt & Kefir', :sort => 6  },
])

User.create({
  :email => "root@localhost.local",
  :password => "password123",
  :password_confirmation => "password123",
  :name => "User Name",
  :state => "Kentucky"
})

10.times do |i|
  Brand.create!({
    :name => "Brand #{i}",
    :store_or_farmers_market => true,
    :order_by_phone => true,
    :order_by_online => false,
    :phone => "867-5309",
    :third_party_available => false,
    :website => "http://www.example.org",
    :approved => true
  })
end

20.times do |i|
  Product.create!({
    :name => "Product #{i}",
    :available => true,
    :category_id => Random.rand(14) + 1,
    :brand_id => Random.rand(9) + 1,
    :approved => true
  })
end

10.times do |i|
  NewsPost.create({
    :title => "New Post Number #{i}",
    :author => "Author #{i}",
    :website => "http://www.example.org",
    :body => "Lorem ipsum or something like that."
  })
end
