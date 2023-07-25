class ApplicationController < ActionController::API
    before_action :authenticate_user
  
    private
  
    def authenticate_user
      token = request.headers['Authorization']&.split(' ')&.last
  
      begin
        decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
        user_id = decoded_token.first['user_id']
        @current_user = User.find_by(id: user_id)
      rescue JWT::DecodeError, JWT::ExpiredSignature
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    end
  
    def current_user
      @current_user
    end
  end
  