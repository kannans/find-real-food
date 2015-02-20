namespace :import_brand_location do
  
  desc "Import Brand and Location from .xlsx file"
  task :import => :environment do
    require 'rubygems'
    require 'bundler/setup'
    require 'fileutils'
    require 'roo'
    require File.expand_path('config/environment')

    import_data_location = Rails.root.join("import_data/")
    processed_files_location = "#{import_data_location}processed/"
    files = Dir["#{import_data_location}*.xlsx"]

    def process_brand_master(row)
      brand_code = row[0].to_s.strip if row[0].present?
      name = row[1].to_s.strip if row[1].present?
      phone = row[2].to_s.strip if row[2].present?
      website = row[3].to_s.strip if row[3].present?
      store_locator_url = row[4].to_s.strip if row[4].present?
      order_by_phone = (row[5] == "TRUE"? true : false)
      order_by_online = (row[6] == "TRUE"? true : false)
      Brand.where(:brand_code => brand_code).first_or_create(:name => name, :phone => phone, :website => website, :store_locator_url => store_locator_url, :order_by_phone => order_by_phone, :order_by_online => order_by_online)
    end

    def process_location_master(row)
      location_code = row[0].to_s.strip if row[0].present?
      name = row[1].to_s.strip if row[1].present?
      address = row[3].to_s.strip if row[3].present?
      city = row[4].to_s.strip if row[4].present?
      state = row[5].to_s.strip if row[5].present?
      zip = row[6].to_s.strip if row[6].present?
      phone = row[7].to_s.strip if row[7].present?
      location_type = row[8].to_s.strip if row[8].present?
      Location.where(:location_code => location_code).first_or_create(:name => name, :address => address, :city => city, :state => state, :zip => zip, :phone => phone, :location_type => location_type)
    end

    def process_raw(row)
      brand = Brand.find_by_brand_code(row[0])
      location = Location.find_by_location_code(row[1])
      BrandsLocation.where(:brand_id => brand.id, :location_id => location.id).first_or_create if brand.present? && location.present?
    end

    files.each do |file|
      unless File.directory?(processed_files_location)
          FileUtils.mkdir_p(processed_files_location)
      end
      file_post_processing = file.sub(import_data_location.to_s, processed_files_location.to_s)

      begin
        importfile = Roo::Excelx.new(file)
        sheets = importfile.sheets.sort

        sheets.each do |sheet|
          case sheet
            when 'Brand Master'
              worksheet = importfile.sheet('Brand Master')
              if worksheet.count > 1  
                2.upto(worksheet.count) do |row_idx|
                  process_brand_master(worksheet.row(row_idx)) if worksheet.row(row_idx).present?
                end
              end
            when 'Location Master'
              worksheet = importfile.sheet('Location Master')
              if worksheet.count > 1  
                2.upto(worksheet.count) do |row_idx|
                  process_location_master(worksheet.row(row_idx)) if worksheet.row(row_idx).present?
                end
              end
            when 'Raw'
              worksheet = importfile.sheet('Raw')
              if worksheet.count > 1  
                2.upto(worksheet.count) do |row_idx|
                  process_raw(worksheet.row(row_idx)) if worksheet.row(row_idx).present?
                end
              end
            else
              Rails.logger.error "Error in data import from xlsx file: Unrecognised sheet #{worksheet}"
          end
        end

        FileUtils.mv(file, file_post_processing)

      rescue => exception
        Rails.logger.error "Error in data import from xlsx file: #{exception.message}"
        FileUtils.mv(file, file_post_processing)
      end
    end
  end
end
