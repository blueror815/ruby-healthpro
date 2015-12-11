class Role < ActiveRecord::Base
  # associations
  has_many :users
  has_and_belongs_to_many :permissions

  # validations
  validates :name, presence: true, length: { maximum: 60 }
  validates :name, uniqueness: { case_sensitive: false }
  validates :short_name, presence: true
  validates :short_name, uniqueness: { case_sensitive: false }

  # callbacks
  before_destroy :has_no_assigned_users?

  accepts_nested_attributes_for :permissions
  # scopes
  scope :role_is_a, ->(name) { find_by(:short_name => name) }

  def self.user_roles
    all.map(&:short_name)
  end

  def has_no_assigned_users?
    users.empty?
  end
end
