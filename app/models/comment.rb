class Comment < ActiveRecord::Base
  # associations
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  # validations
  validates :content, presence: true
  validates :user, presence: true

  def receivers
    (self.commentable.comments.map(&:user) << self.commentable.user).uniq
  end
end
