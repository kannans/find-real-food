class Api::BrandsController < Api::BaseController
  respond_to :json

  api :GET, '/brands/:brand_id', 'Get a specific brand'
  def show
    brand = Brand.find(params[:id])
    respond_to do |format|
      format.json { render_for_api :brand, :json => brand, :meta => { :success => true} }
    end
  end

  def_param_group :brand do
    param :brand, Hash, :required => false do
      param :name, String
      param :order_by_online, :bool
      param :order_by_phone, :bool
      param :phone, String
      param :third_party_available, :bool
      param :website, String
    end
  end

  api :GET, '/brands', "List Brands"
  desc <<-EOS
    Returns a list of all brands in the following format:
      {
          "success": true,
          "brands": [
              {
                  "id": 1,
                  "store_or_farmers_market": true,
                  "name": "Brand Name",
                  "order_by_online": true,
                  "order_by_phone": false,
                  "phone": "123-456-1234",
                  "third_party_available": true,
                  "website": null,
                  "picture": "/assets/blank.png",
                  "approved": true
              }
          ]
      }
  EOS

  def index
    brands = Brand.approved
    respond_to do |format|
      format.json { render_for_api :brand, :json => brands,
        :meta => { :success => true}, :root => :brands }
    end
  end

  api :POST, '/brands', "Create a Brand"
  param_group :brand
  formats ['json']
  desc <<-EOS
    Accepts brand formatted as:
    Returns newly created brand:
  EOS

  def create
    params[:brand][:store_farmers_market] = params[:brand][:store_or_farmers_market] unless params[:brand][:store_or_farmers_market].nil?
    params[:brand][:skip_processing] = true
    params[:brand].delete(:image_data) if params[:brand][:image_data].nil?

    if params[:brand][:image_data]
      cover_photo_data = params[:brand][:image_data]
      params[:brand].delete(:image_data)
    end

    @resource = Brand.new(params[:brand])

    begin
      @resource.user = current_user

      @resource.picture = RealFood::ImageDecoder.decode_jpg(cover_photo_data) if cover_photo_data

      @resource.save!
      respond_to do |format|
        format.json { render_for_api :brand, :json => @resource,
          :meta => { :success => true}, :root => :brand}
      end
    rescue Exception => e
      render :json => { :success => false, :message => e.message}
    end
  end
end
