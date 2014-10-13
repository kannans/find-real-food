require 'spec_helper'

describe Api::ProductsController do

  describe 'json responses' do

    describe 'create new product' do

      before (:each) do
        product = FactoryGirl.create(:product)
        post :create, :format => 'json', :api_template => :product, :product => {:name => product[:name]}
      end

      it 'should respond with HTTP 200' do
        expect(response).to be_success
      end

      it 'should have a product name assigned' do
        body = JSON.parse(response.body)
        body["product"]["name"].should ==  "MyString"
      end

      it {should have_many(:flag_requests)}
    end
  end
end
