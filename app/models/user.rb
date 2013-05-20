# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible(:name, :email, :password,
                  :password_confirmation)

  # Use the built-in has_secure_password method to
  # compare an encrypted password with the password_digest
  # so that we can successfully authenticate the user
  has_secure_password

  # Lowercase the user's email address to ensure uniqueness
  before_save { |user| user.email = email.downcase }

  # Validate the user's name
  validates(:name, presence: true, length: { maximum: 50 })
  
  # Create a Regex expression for validating email addresses
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Validate the user's email address
  validates(:email, presence: true,
  			            format: { with: VALID_EMAIL_REGEX },
  			            uniqueness: { case_sensitive: false })

  # Validate the user's password
  validates(:password, presence: true,
  			               length: { minimum: 6 })

  # Validate that the password confirmation field has been
  # filled out
  validates(:password_confirmation, presence: true)
end