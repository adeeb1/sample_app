class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  # Order the microposts by the date created. The "DESC" is an SQL variable for "descending." Therefore, the microposts will be in descending order from newest to oldest
  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by(user)
  	# Write an SQL query collection of the users that 'user' is following
  	followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"

  	# Use an SQL query to show the microposts from only those users that 'user' is following. The "Microposts" keyword isn't necessary here since we are in the Micropost model and the "self" keyword is being used in the function name
  	where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user)
  end
end