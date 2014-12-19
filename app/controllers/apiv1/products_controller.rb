class Apiv1::ProductsController < Apiv1::BaseController
  respond_to :json

  api :GET, '/brands/:brand_id/products', "View products in a brand"
  desc "Lists products in a given brand"
  def index
    products = Product.where(:brand_id => params[:brand_id]).approved
    respond_to do |format|
      format.json { render_for_api :product, :json => products, :meta => { :success => true}, :root => :products }
    end
  end

  api :GET, '/products/:product_id', "View product details"
  desc "Returns a single product"
  def show
    product = Product.find(params[:id])
    respond_to do |format|
      format.json { render_for_api :product, :json => product, :meta => { :success => true}, :root => :products }
    end
  end

  api :POST, '/products', "Create a product"
  desc "Create a product"
  param :product, Hash do
    param :name, String
    param :category_id, Integer
    param :brand_id, Integer
    param :quality_rating_id, Integer
  end

  def create
    params[:product].delete(:image_data) if params[:product][:image_data].nil?
    params[:product][:skip_processing] = true

    if params[:product][:image_data]
      cover_photo_data = params[:product][:image_data]
      params[:product].delete(:image_data)
    end

    resource = current_user.products.new(params[:product])

    begin
      resource.picture = RealFood::ImageDecoder.decode_jpg(cover_photo_data) if cover_photo_data

      resource.user = current_user
      resource.user_id = current_user.id

      resource.save!

      current_user.save!

      respond_to do |format|
        format.json { render_for_api :product, :json => resource,
          :meta => { :success =>true}, :root => :product}
      end
    rescue Exception => e
      render :json => { :success => false, :message => e.message}
    end

  end
end
