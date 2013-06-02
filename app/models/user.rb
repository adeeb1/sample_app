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

  # State that each user has multiple microposts. The 'dependent: :destroy' option arranges for the user's microposts to be destroyed when the user itself is destroyed
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  # Include the class name in this association because Rails would look for a ReverseRelationship class otherwise
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

  # The source is not needed in this case because Rails will singularize "followers" and automatically look for the foreign key, 'follower_id.'
  has_many :followers, through: :reverse_relationships, source: :follower

  # Lowercase the user's email address to ensure uniqueness
  before_save { email.downcase! }
  before_save :create_remember_token

  # Validate the user's name
  validates(:name, presence: true, length: { maximum: 50 })
  
  # Create a Regex expression for validating email addresses
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Validate the user's email address
  validates(:email, presence: true,
  			            format: { with: VALID_EMAIL_REGEX },
  			            uniqueness: { case_sensitive: false })

  # Validate the user's password
  validates(:password, length: { minimum: 6, allow_blank: true })

  # Implementation of micropost status feed
  def feed
    # Preliminary implementation
    # The "?" ensures that the 'id' is properly escaped before being included in the underlying SQL query. This is more secure than inserting the 'id' into the SQL query directly because SQL injection would be possible otherwise
    
    #Micropost.where("user_id = ?", id)

    # Display a feed of microposts for only the users that the user is following
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end  

  def send_password_reset
    # Generate the password reset token
    generate_token(:password_reset_token)

    # State the time we sent the password reset request at
    self.password_reset_sent_at = Time.zone.now

    # Save the user model
    save!
    
    # Send the password reset email
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      # Use the SecureRandom class to generate a random string
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  private
    def create_remember_token
      # Use the SecureRandom class to generate a random string
      self.remember_token = SecureRandom.urlsafe_base64
    end
end