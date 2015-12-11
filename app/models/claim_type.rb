class ClaimType < ActiveRecord::Base
  # associations
  has_many :bills
  has_many :payments

  # validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # callbacks
  before_save :titleize_name

  private
    def titleize_name
      self.name.downcase.titleize
    end
end
