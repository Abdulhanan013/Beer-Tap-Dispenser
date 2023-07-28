class User < ApplicationRecord
    # Include BCrypt for password encryption
    has_secure_password
    has_many :dispensers
    has_many :dispenser_events
  
    # Validate presence of name, email, and role
    validates :name, :email, :role, presence: true
  
    # Ensure unique email
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
    # Define the role as an enum
    enum role: { attendee: 'attendee', admin: 'admin', promoter: 'promoter' }
  
    # Validate role is one of the available roles
    validates :role, inclusion: { in: roles.keys }
  end
  