
require 'spec_helper'

describe Api::RatingsController do
  render_views
  let(:product) { FactoryGirl.create(:product) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'json responses' do
    describe 'create new rating associated with a user' do
      before (:each) do
        params = { :ratable_type => "product", :ratable_id => product.id, :rating => {:rating => 5, :user_id => user.id} }
        post :create, params, :format => :json
      end

      it 'should respond with HTTP 200' do
        response.should be_success
      end

      it 'should have a rating assigned' do
        body = JSON.parse(response.body)
        body["rating"]["rating"].should == (5)
      end
    end
  end
end
