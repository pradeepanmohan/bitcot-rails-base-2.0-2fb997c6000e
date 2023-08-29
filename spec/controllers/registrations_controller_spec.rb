require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    it 'creates a new user with valid attributes' do
      user_attributes = FactoryBot.attributes_for(:user)
      post :create, params: { user: user_attributes }, format: :json

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response['user']['email']).to eq(user_attributes[:email])
    end

    it 'returns errors if invalid user data is provided' do
      post :create, params: { user: { email: 'invalid_email', password: '12345678' } }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to include("Email is invalid")
    end
  end
end
