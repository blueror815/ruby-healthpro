class PaymentType < ActiveRecord::Base
  # associations
  has_many :payments

  # validations
  validates :name, presence: true, uniqueness: true
end
