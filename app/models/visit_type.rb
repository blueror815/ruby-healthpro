class VisitType < ActiveRecord::Base
  # associations
  has_many :visits
  has_many :payment_rates
  has_many :job_types_visit_types
  has_many :job_types, through: :job_types_visit_types
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :reimbursements

  # validations
  validates :title, presence: true, length: { maximum: 60 }
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, if: lambda { |object| object.price.present? }

  # callbacks
  after_save :update_visit_reimbursments
  after_save :update_visit_prices


  private
  #TODO_PROHEALTH move to delayed job
  def update_visit_prices
    self.visits.price_editable_visits.each do |visit|
      visit.update_visit_total_price
    end
  end

  def update_visit_reimbursments
    self.visits.each do |visit|
      visit.set_reimbursements
    end
  end
end
