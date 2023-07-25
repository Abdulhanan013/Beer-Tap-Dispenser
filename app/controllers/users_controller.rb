class UsersController < ApplicationController
    before_action :authenticate_user, except: [:create]
  
    def create
      user = User.new(user_params)
  
      if user.save
        render json: { message: 'User created successfully' }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      render json: @current_user
    end
  
    def update
      if @current_user.update(user_params)
        render json: { message: 'User updated successfully' }, status: :ok
      else
        render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @current_user.destroy
      render json: { message: 'User deleted successfully' }, status: :ok
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end
  end
  