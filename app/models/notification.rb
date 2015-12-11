class Notification < ActiveRecord::Base
  default_scope { order('updated_at DESC') }
  
  #validations
  validates :receiver_id, :notifiable_id, :notifiable_type, presence: true

  # associations
  belongs_to :notifiable, :polymorphic => true
  has_many :user_notifications
  has_many :senders, through: :user_notifications
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  #scopes
  scope :of, lambda { |user| where(:receiver_id => user.id)}
  scope :read_by, lambda { |user| where(:receiver_id => user.id, read: true)}
  scope :unread_by, lambda { |user| where(:receiver_id => user.id, read: false)}
  scope :unread, lambda { where(read: false)}

  def self.mark_all_as_read!(options = {})
    if options[:for]
      Notification.unread_by(options[:for]).update_all(read: true)
    else
      Notification.unred.update_all(read: true)
    end
  end

  def self.mark_as_read!(notifications)
    notifications.each do |notification| 
      notification.update(read: true)
    end
  end
end
