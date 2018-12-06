class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  validate :user_can_not_follow_himself

  private 
    def user_can_not_follow_himself
      return follower_id != followed_id
    end
end
