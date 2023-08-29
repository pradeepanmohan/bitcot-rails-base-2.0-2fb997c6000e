require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    user =  FactoryBot.create(:user, email: 'test@example.com', password: 'password123')

    user.update(confirmed_at: Time.now)

    it 'signs in a user with valid credentials' do
      post :create, params: { user: { email: 'test@example.com', password: 'password123' } }, format: :json

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response['user']['email']).to include('test@example.com')
    end

    it 'returns an error with invalid credentials' do
      post :create, params: { user: { email: 'test@example.com', password: 'wrong_password' } }, format: :json

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Invalid email or password')
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { FactoryBot.create(:user) }

    it 'signs out a signed-in user' do
      sign_in(user)
      delete :destroy, format: :json

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response['success']).to eq('User signed out successfully')
    end

    it 'returns an error if user sign-out fails' do
      allow(controller).to receive(:sign_out).and_return(false)

      sign_in(user)
      delete :destroy, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Failed to sign out')
    end
  end
end
