class CoverageArea < ActiveRecord::Base
  # validateions
  validates :name, presence: true, length: { maximum: 60 }

  # Associaitons
  has_and_belongs_to_many :users
end
