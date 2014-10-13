require 'spec_helper'

describe Api::SearchesController do

  describe 'json responses' do
    str = "my"
    quality = "good"

    6.times do
      FactoryGirl.create(:brand)
      FactoryGirl.create(:location)

    end

    ["apple", "fumy", "my mother's milk"].cycle(1) do |prod|
      product = FactoryGirl.create(:product, :category_id => "1", :name => prod)
      rating = FactoryGirl.create(:rating, :ratable_type => "Product", :ratable_id => product.id, :rating => "2")
    end

    ["people", "zebra", "olmygorphic"].cycle(1) do |prod|
      product = FactoryGirl.create(:product, :category_id => "2", :name => prod)
      rating = FactoryGirl.create(:rating, :ratable_type => "Product", :ratable_id => product.id, :rating => "5")
    end

    ["good", "best", ""].cycle(2) do |quality|
      @category = FactoryGirl.create(:category)
      @quality_rating = FactoryGirl.create(:quality_rating, :value => quality,
        :category => @category)
    end
    ["a", "b", "my", "d", "all my", "f"].cycle(1) do |name|
      @user = FactoryGirl.create(:user, name: name)
    end

    describe 'search all' do

      before (:each) do
        get :search, :format => 'json', :q => {:name_cont => str}
      end

      it 'should respond with HTTP 200' do
        expect(response).to be_success
      end

      it 'should return a list of results' do
        body = JSON.parse(response.body)
        body.should have_key("brands")
        body.should have_key("categories")
        body.should have_key("locations")
        body.should have_key("products")
        body.should have_key("users")
      end
    end



    describe 'search filtered' do
      before (:each) do
        get :search, :format => 'json', :q => {:name_cont => str, :filter => "brands"}
      end

      it 'should respond with HTTP 200' do
        expect(response).to be_success
      end

      it 'should return a list of results' do
        body = JSON.parse(response.body)
        body.should have_key("brands")
      end
    end

    describe 'search by minimum quality-rating' do

      before (:each) do
        get :search, :format => 'json', :q => {:name_cont => str,
          :filter => "category", :quality_ratings_value_eq => quality, :s => "id desc"}
      end

      it 'should respond with HTTP 200' do
        expect(response).to be_success
      end

      it 'should return a list of results' do
        body = JSON.parse(response.body)
        body["categories"].size.should eql(2)
        body.should have_key("categories")
      end
    end

    describe 'sort by user ratings' do

      before (:each) do
        get :search, :format => 'json', :q => {:filter => "product",
          :name_cont => "pl", :s => "ratings_rating desc"}
      end

      it 'should respond with HTTP 200' do
        expect(response).to be_success
      end

      it 'should return a list of results' do
        body = JSON.parse(response.body)
        body.should have_key("products")
      end
    end
  end
end
