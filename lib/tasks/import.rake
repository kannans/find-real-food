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
  

  task :brandsnew => :environment do
    file = "import_data/branddata-03-nov.csv"
    CSV.foreach(file, :headers => true) do |row|
      
      if row[5] == 'T'
        order_by_phone = 1
      else
        order_by_phone = 0
      end

      if row[6] == 'T'
        order_by_online = 1
      else
        order_by_online = 0
      end

      if row[7] == 'T'
        store_farmers_market = 1
      else
        store_farmers_market = 0
      end

      if row[8] == 'T'
        third_party_available = 1
      else
        third_party_available = 0
      end

       brand = Brand.where(:name => row[1]).first
      if brand
        brand = Brand.create!({
        :brand_code => row[0],
        :name => row[1],
        :phone => row[2],
        :website => row[3],
        :store_locator_url => row[4],
        :order_by_phone => order_by_phone,
        :order_by_online => order_by_online,
        :store_farmers_market => store_farmers_market,
        :third_party_available => third_party_available
        })

      else

      brand.update_attributes({
        :brand_code => row[0],
        :name => row[1],
        :phone => row[2],
        :website => row[3],
        :store_locator_url => row[4],
        :order_by_phone => order_by_phone,
        :order_by_online => order_by_online,
        :store_farmers_market => store_farmers_market,
        :third_party_available => third_party_available
      })

      end
      
 

    end
  end
  

  task :brandlinklocate => :environment do
    file = "import_data/brandlocationdata-03-nov.csv"
    CSV.foreach(file, :headers => true) do |row|
      brand_code = row[0]
      location_code = row[1]
       brand = Brand.where("brand_code='#{brand_code}'").first
       location = Location.where("location_code='#{location_code}'").first

       if brand && location
        connection = ActiveRecord::Base.connection()
         results = connection.execute("insert into brands_locations (brand_id,location_id) values('#{brand.id}', '#{location.id}')")
         
        
         product = Product.where(:brand_id=>brand.id)
        
         product.each do |pro|
          connection = ActiveRecord::Base.connection()
          results = connection.execute("insert into locations_products (product_id,location_id) values('#{pro.id}', '#{location.id}')")
        end

      end


    end
  end
  

  task :brandsnewd => :environment do
    file = "import_data/branddata-03-nov.csv"
    CSV.foreach(file, :headers => true) do |row|
       
        
       brand = Brand.where(:name => row[1]).first
      if brand.nil?
        brand = Brand.create!({
        :brand_code => row[0],
        :name => row[1],
        :phone => row[2],
        :website => row[3],
        :store_locator_url => row[4],
        :order_by_phone => row[5],
        :order_by_online => row[6],
        :third_party_available => row[8]
        })
      else

      brand.update_attributes({
        :brand_code => row[0],
        :name => row[1],
        :phone => row[2],
        :website => row[3],
        :store_locator_url => row[4],
        :order_by_phone => row[5],
        :order_by_online => row[6],
        :third_party_available => row[8]
      })

      end
      
 

    end
  end
  
  


  task :locationsnew => :environment do
    file = "import_data/locationdata-03-nov.csv"
    CSV.foreach(file, :headers => true) do |row|
      
       if row[9]
        parent = Location.where(:location_code => row[9]).first
       else
        parent = 0
       end 
       puts "#{row[0]}"
       location = Location.where(:name => row[1]).first
      if location.nil?
        location = Location.create!({
        :location_code => row[0],
        :name => row[1],
        :address => row[2],
        :city => row[3],
        :state => row[4],
        :zip => row[5],
        :phone => row[6],
        :location_type => row[7],
        :parent_id => parent
        })
        next
      else

      location.update_attributes({
        :location_code => row[0],
        :name => row[1],
        :address => row[2],
        :city => row[3],
        :state => row[4],
        :zip => row[5],
        :phone => row[6],
        :location_type => row[7],
        :parent_id => parent
      })

      end
      
 

    end
  end
  

   task :productupdate => :environment do
       products = Product.all
       products.each do |pro|
         productval = Product.where(:id => pro.id).first
          next if productval.nil?
         productval.update_attributes({
          :name => pro.name
        })
       end
  end

  task :brandupdate => :environment do
       brands = Brand.all
       brands.each do |bra|
         brandval = Brand.where(:id => bra.id).first
          next if brandval.nil?
         brandval.update_attributes({
          :name => bra.name
        })
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
  
  task :locationupdate => :environment do
       locations = Location.where("slug='' || state =''").all
       state = ''
       locations.each do |l|
         location = Location.where(:id => l.id).first
         if location.zip
          zipcode = location.zip
          connection = ActiveRecord::Base.connection()
          results = connection.execute("select STATE from master_zipcode where ZIP_CODE='#{zipcode}' limit 1")
          results.each do |row|
            state =  row[0]
          end
          location.update_attributes({
            :state => state
          })
         end
         
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
