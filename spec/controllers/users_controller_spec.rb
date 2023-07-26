# spec/controllers/users_controller_spec.rb

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    it 'creates a new user' do
      post :create, params: { user: { name: 'John Doe', email: 'john@example.com', password: 'password', role: 'attendee' } }
      expect(response).to have_http_status(:created)
      expect(User.count).to eq(1)
    end

    it 'returns error for invalid user data' do
      post :create, params: { user: { name: '', email: 'invalid_email', password: 'password', role: 'attendee' } }
      expect(response).to have_http_status(:unprocessable_entity)
      response_data = JSON.parse(response.body)
      expect(response_data['errors']).to include("Name can't be blank", "Email is invalid")
      expect(User.count).to eq(0)
    end
  end

  describe 'GET #show' do
    it 'returns the current user' do
      user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password', role: 'attendee')
      token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256')

      request.headers['Authorization'] = "Bearer #{token}"
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      response_data = JSON.parse(response.body)
      expect(response_data['name']).to eq('John Doe')
      expect(response_data['email']).to eq('john@example.com')
      expect(response_data['role']).to eq('attendee')
    end

    it 'returns unauthorized for missing or invalid token' do
      get :show, params: { id: 1 }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PATCH #update' do
    it 'updates the current user' do
      user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password', role: 'attendee')
      token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256')

      request.headers['Authorization'] = "Bearer #{token}"
      patch :update, params: { id: user.id, user: { name: 'Updated Name' } }
      expect(response).to have_http_status(:ok)
      user.reload
      expect(user.name).to eq('Updated Name')
    end

    it 'returns unauthorized for missing or invalid token' do
      patch :update, params: { id: 1, user: { name: 'Updated Name' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the current user' do
      user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password', role: 'attendee')
      token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256')

      request.headers['Authorization'] = "Bearer #{token}"
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(User.count).to eq(0)
    end

    it 'returns unauthorized for missing or invalid token' do
      delete :destroy, params: { id: 1 }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
