require 'csv'

namespace :import do
  task :quality   => :environment do
    file = "import_data/quality.csv"
    CSV.foreach(file, :headers => true, :header_converters => [:symbol, :downcase]) do |row|
      category = Category.where(:title => row[:category]).first
      next if category.nil?

      category.quality_ratings.create({ :name => 'Best', :value => row[:best].strip })
      category.quality_ratings.create({ :name => 'Good', :value => row[:good].strip })
      category.quality_ratings.create({ :name => 'Avoid', :value => row[:avoid].strip })
    end
  end

  task :brands => :environment do
    file = "import_data/brand_master.csv"
    CSV.foreach(file, :headers => true) do |row|
      order_by_phone = row[3] == 'Yes'
      order_by_online = row[4] == 'Yes'
      image = "import_data/images/brands/#{row[5]}.jpg"

      brand = Brand.create!({
        :name => row[0],
        :phone => row[1],
        :website => row[2],
        :order_by_phone => order_by_phone,
        :order_by_online => order_by_online,
        :approved => true
      })

      puts "#{image} -- #{File.exists?(image)}"

      #if File.exists?(image)
      #  brand.picture = File.open(image)
      #  brand.save
      #end

    end
  end

  task :category => :environment do
    file = "import_data/category_master.csv"
    CSV.foreach(file, :headers => true) do |row|
      
      brand = Category.create!({
        :title => row[0],
        :created_at => row[1],
        :updated_at => row[2],
        :sort => row[3]
      })

    end
  end

  task :category_data => :environment do
    file = "import_data/category_master.csv"
    CSV.foreach(file, :headers => true) do |row|
      
      category = Category.where(:title => row[0]).first
      next if category.nil?

       category.update_attributes({
        :sort => row[1]
      })
       

      

    end
  end

  task :brands_data => :environment do
    file = "import_data/brand_master.csv"

    CSV.foreach(file, :headers => true) do |row|
      order_by_phone = row[3] == 'Yes'
      order_by_online = row[4] == 'Yes'

      online_retailer = row[6] == 'Yes'
      established_grocery = row[7] == 'Yes'
      farm_retail = row[8] == 'Yes'
      farmers_market = row[9] == 'Yes'

      brand = Brand.where(:name => row[0]).first
      if brand.nil?
        puts "Brand not found: #{row[0]}"
        next
      end

      brand.update_attributes({
        :order_by_online => order_by_online,
        :order_by_phone => order_by_phone,
        :store_or_farmers_market => established_grocery || farm_retail || farmers_market,
        :third_party_available => online_retailer
      })
    end
  end

  task :products => :environment do
    file = "import_data/product_master.csv"
    CSV.foreach(file, :headers => true) do |row|
      category = Category.where(:title => row[1]).first

      if category.nil?
        puts "Category not found: #{row[1]}"
        next
      end

      brand = Brand.where(:name => row[0]).first

      if brand.nil?
        puts "Brand not found: #{row[0]}"
        next
      end

      rating = QualityRating.where(:category_id => category.id, :name => row[3]).first

      if rating.nil?
        puts "Quality Rating not found: #{row[0]} - #{row[1]} - #{row[2]} - #{row[3]}"
        next
      end

      product = Product.create!({
        :name => row[2],
        :category_id => category.id,
        :brand_id => brand.id,
        :quality_rating_id => rating.id,
        :approved => true
      })

      image = "import_data/images/products/#{row[0]}/#{row[5]}.jpg"
      puts "#{image} -- #{File.exists?(image)}"

      if File.exists?(image)
        product.picture = File.open(image)
        product.save
      end
    end
  end
  task :products_test => :environment do
    file = "import_data/product_master.csv"
    CSV.foreach(file, :headers => true) do |row|
        product = Product.create!({
        :name => row[4],
        :id => row[0],
        :category_id => row[2],
        :brand_id => row[3],
        :quality_rating_id => row[5],
        :approved => true
      })
      
    end
  end

task :rating_test => :environment do
    file = "import_data/rating_master.csv"
    CSV.foreach(file, :headers => true) do |row|
        rating = Rating.create!({
        :user_id => row[1],
        :ratable_id => row[2],
        :ratable_type => row[3],
        :rating => row[4],
        :created_at => row[5],
        :updated_at => row[6],
        :comment => row[7]
      })
      
    end
  end


end
