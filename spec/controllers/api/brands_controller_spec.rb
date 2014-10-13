require 'spec_helper'

describe Api::BrandsController do

  describe 'json responses' do

    describe 'create new brand' do

      before (:each) do
        name = "miriam"
        post :create, :format => 'json', :api_template => :brand, :brand => {:name => name, :order_by_online => true}
      end

      it 'should respond with HTTP 200' do
        expect(response).to be_success
      end

      it 'should have a brand name assigned' do
        name = "miriam"
        body = JSON.parse(response.body)
        body["brand"]["name"].should ==  name
      end
    end
  end
end
