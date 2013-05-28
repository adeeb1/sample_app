class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  # Order the microposts by the date created. The "DESC" is an SQL variable for "descending." Therefore, the microposts will be in descending order from newest to oldest
  default_scope order: 'microposts.created_at DESC'
end