class AuthenticationController < ApplicationController
    before_action :authenticate_user, except: [:login]
    def login
      user = User.find_by(email: params[:email])
  
      if user&.authenticate(params[:password])
        jwt_token = issue_token(user_id: user.id)
        render json: { token: jwt_token }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    private
  
    def issue_token(payload)
      JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
    end
  end
  