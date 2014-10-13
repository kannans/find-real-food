require 'spec_helper'

describe Api::FeedbacksController do

  describe 'json responses' do

    describe 'create new feedback' do
      name = "miriam"
      before (:each) do

        post :create, :format => 'json', :api_template => :feedback, :feedback => {:subject => name}
      end

      it 'should respond with HTTP 200' do
        expect(response).to be_success
      end

      it 'should have a feedback subject assigned' do
        body = JSON.parse(response.body)
        body["feedback"]["subject"].should ==  name
      end
    end
  end
end