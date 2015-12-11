class UserNotification < ActiveRecord::Base
  default_scope { order('updated_at DESC') }

  #associations
  belongs_to :notification
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
end
