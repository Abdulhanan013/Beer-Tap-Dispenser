class User < ApplicationRecord
    # Include BCrypt for password encryption
    has_secure_password
  
    # Validate presence of name, email, and role
    validates :name, :email, :role, presence: true
  
    # Ensure unique email
    validates :email, uniqueness: true
  
    # Define available roles
    ROLES = %w[attendee admin]
  
    # Validate role is one of the available roles
    validates :role, inclusion: { in: ROLES }
  end
  