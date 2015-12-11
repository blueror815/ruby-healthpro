class Permission < ActiveRecord::Base
  validates :object_type, :action_name, presence: true
  validates :object_type, uniqueness: {scope: :action_name}

  has_and_belongs_to_many :roles
end
