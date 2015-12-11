class Reimbursement < ActiveRecord::Base
  # associations
  has_and_belongs_to_many :visit_types
  has_many :reimbursements_visits
  has_many :visits, through: :reimbursements_visits
  has_many :payment_rates
  has_many :reimbursement_timesheets

  # validations
  validates :title, presence: true, length: { maximum: 60 }
  validates :price, presence: true
  validates :price, numericality: { only_decimal: true, greater_than_or_equal_to: 0 }, if: lambda { |object| object.price.present? }
  validates :value_type, presence: true
  validate :value_type_valid

  # callback
  after_save :update_visit_price

  # TODO_PROHEALTH add validation for types

  # constants
  TYPES = { 1 => 'single instance', 2 => 'multiple instances', 3 => 'custom' }

  # scopes
  scope :timesheet_allowables, -> { where(include_in_timesheet: true) }

  # instance methods
  def riembursement_price(assignee = nil)
    if assignee
      assignee.payment_rates.find_by(reimbursement_id: self.id).try(:price) || self.price
    else
      self.price
    end
  end

  private

  def update_visit_price
    self.visits.each do |visit|
      visit.update_visit_total_price
    end
  end

  def value_type_valid
    errors.add(:value_type, 'is invalid') unless TYPES.keys.include? value_type
  end
end
