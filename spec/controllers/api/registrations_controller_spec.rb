require 'spec_helper'

describe Api::RegistrationsController do

  describe 'json responses' do

    describe 'create new user' do
      password = "miriam12"
      email = "momo@momo.com"
      avatar_data = File.read("app/assets/images/test.jpg")
      cover_photo_data = File.read("app/assets/images/test.jpg")

      before (:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]

        post :create, :format => 'json', :api_template => :user, :user => {
          :password => password,
          :email => email,
          :avatar_data => Base64.encode64(avatar_data),
          :cover_photo_data => Base64.encode64(cover_photo_data)
        }
      end

      it 'should respond with HTTP 200' do
        expect(response).to be_success
      end

      it 'should save the user avatar image' do
        body = JSON.parse(response.body)
        u = User.last
        u.avatar.should_not be_nil
        u.cover_photo.should_not be_nil
      end
    end
  end
end
