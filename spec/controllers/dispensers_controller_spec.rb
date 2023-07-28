require 'rails_helper'

RSpec.describe DispensersController, type: :controller do
  # Helper method to generate a JWT token for a user
  def generate_token_for_user(user)
    JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256')
  end

  describe 'POST #create' do
    context 'when an admin user creates a dispenser' do
      let(:admin_user) { User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', role: 'admin') }
      before { request.headers['Authorization'] = "Bearer #{generate_token_for_user(admin_user)}" }

      it 'creates a new dispenser' do
        post :create, params: { dispenser: { name: 'Test Dispenser', flow_volume: 10 } }
        expect(response).to have_http_status(:created)
        expect(Dispenser.count).to eq(1)
      end
    end

    context 'when a non-admin user tries to create a dispenser' do
      let(:non_admin_user) { User.create(name: 'Non-Admin User', email: 'nonadmin@example.com', password: 'password', role: 'attendee') }
      before { request.headers['Authorization'] = "Bearer #{generate_token_for_user(non_admin_user)}" }

      it 'returns forbidden error' do
        post :create, params: { dispenser: { name: 'Test Dispenser', flow_volume: 10 } }
        expect(response).to have_http_status(:forbidden)
        expect(Dispenser.count).to eq(0)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq('Only admin users can create dispensers.')
      end
    end
  end

  describe 'PATCH #update' do
    let(:admin_user) { User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', role: 'admin') }
    let(:attendee_user) { User.create(name: 'Attendee User', email: 'attendee@example.com', password: 'password', role: 'attendee') }
    let(:dispenser) { Dispenser.create(name: 'Dispenser', flow_volume: 20, user_id: admin_user.id ) }

    context 'when an admin user updates a dispenser' do
      before { request.headers['Authorization'] = "Bearer #{generate_token_for_user(admin_user)}" }

      it 'updates the dispenser' do
        patch :update, params: { id: dispenser.id, status: 'open' }
        expect(response).to have_http_status(:ok)
        expect(dispenser.reload.status).to be_truthy
      end
    end

    context 'when an attendee user updates a dispenser' do
      before { request.headers['Authorization'] = "Bearer #{generate_token_for_user(attendee_user)}" }

      it 'updates the dispenser' do
        patch :update, params: { id: dispenser.id, status: 'open' }
        expect(response).to have_http_status(:ok)
        expect(dispenser.reload.status).to be_truthy
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:admin_user) { User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', role: 'admin') }
    let(:attendee_user) { User.create(name: 'Attendee User', email: 'attendee@example.com', password: 'password', role: 'attendee') }
    let(:dispenser) { Dispenser.create(name: 'Dispenser', flow_volume: 20, user_id: admin_user.id ) }

    context 'when an admin user deletes a dispenser' do
      before { request.headers['Authorization'] = "Bearer #{generate_token_for_user(admin_user)}" }

      it 'deletes the dispenser' do
        delete :destroy, params: { id: dispenser.id }
        expect(response).to have_http_status(:ok)
        expect(Dispenser.count).to eq(0)
      end
    end

    context 'when a non-admin user tries to delete a dispenser' do
      before { request.headers['Authorization'] = "Bearer #{generate_token_for_user(attendee_user)}" }

      it 'returns forbidden error' do
        delete :destroy, params: { id: dispenser.id }
        expect(response).to have_http_status(:forbidden)
        expect(Dispenser.count).to eq(1)
      end
    end
  end

  describe 'GET #total_statistics' do
    let(:admin_user) { User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', role: 'admin') }
    let(:promoter_user) { User.create(name: 'Promoter User', email: 'promoter@example.com', password: 'password', role: 'promoter') }
    let(:attendee_user) { User.create(name: 'Attendee User', email: 'attendee@example.com', password: 'password', role: 'attendee') }
    let!(:dispenser1) { Dispenser.create(name: 'Dispenser 1', flow_volume: 20, user_id: admin_user.id) }
    let!(:dispenser2) { Dispenser.create(name: 'Dispenser 2', flow_volume: 15, user_id: admin_user.id) }

    context 'when a promoter user requests total statistics' do
      before { request.headers['Authorization'] = "Bearer #{generate_token_for_user(promoter_user)}" }

      it 'returns total earnings and total usage time for all dispensers' do
        # Set dispenser1 status and total_liters (assume 5 liters sold)
        # dispenser1.update(status: false)
        dispenser1.dispenser_events.create(event_type: 'close', start_time: Time.now - 2.hours, end_time: Time.now - 1.hour, liters: 5, price: 5, user_id: attendee_user.id)

        # Set dispenser2 status and liters (assume 8 liters sold)
        # dispenser2.update(status: false)
        dispenser2.dispenser_events.create(event_type: 'close', start_time: Time.now - 1.hour, end_time: Time.now, liters: 8, price: 8, user_id: attendee_user.id)
        get :total_statistics
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['total_earnings']).to eq(13) # Total earnings = 5 + 8 = 13
        expect(parsed_response['total_usage_time']).to eq(1.hour + 1.hour) # Total usage time = 2 hours
      end
    end

    context 'when a user with role other than promoter requests total statistics' do
      let(:non_promoter_user) { User.create(name: 'Non-Promoter User', email: 'nonpromoter@example.com', password: 'password', role: 'attendee') }
      before { request.headers['Authorization'] = "Bearer #{generate_token_for_user(non_promoter_user)}" }

      it 'returns forbidden error' do
        get :total_statistics
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
