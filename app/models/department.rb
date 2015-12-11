class Department < ActiveRecord::Base
  # associations
  has_and_belongs_to_many :users
  has_and_belongs_to_many :visit_types
  has_and_belongs_to_many :hour_types

  # validations
  validates :name, presence: true, uniqueness: true, length: { maximum: 60 }
end
