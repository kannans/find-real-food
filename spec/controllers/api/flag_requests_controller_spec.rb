
require 'spec_helper'

describe Api::FlagRequestsController do

  describe 'json responses' do

    describe 'create a flag request associated with a product' do

      before (:each) do
        str = 'something'
        @product = Product.create(:name => 'Test')
        id = @product.id
        post :create, :format => 'json', :api_template => :flag_request,
        :flag_request => {:name => str, :product_id => id }
      end

      it 'should return a success message' do
        expect(response).to be_success
      end

      it 'should have a flag_request name assigned' do
        body = JSON.parse(response.body)
        body["flag_request"]["name"].should == 'something'
      end

      it 'should have a an associated product' do
        @product.flag_requests.count.should  eql(1)
      end
    end
  end
end