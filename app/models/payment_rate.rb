class PaymentRate < ActiveRecord::Base
  # associations
  belongs_to :user
  belongs_to :visit_type
  belongs_to :hour_type
  belongs_to :reimbursement
  has_one :job_type, through: :user

  # validations
  validates :payment_method_id, presence: true
  validates :visit_type_id, presence: true, if: lambda { |i| i.payment_method_id == 1 }
  validates_associated :user

  # callbacks
  before_save :set_default_price
  after_save :update_related_visit_price
  after_save :update_related_hours_price

  # scopes
  scope :hourly, -> { where(payment_method_id: 2) }
  scope :per_visit, -> { where.not(visit_type_id: nil) }
  scope :reimbursement_types, -> { where.not(reimbursement_id: nil) }
  scope :fixed_salery, -> { where(payment_method_id: "3") }

  # instance methods
  def hour?
    payment_method_id == 2
  end

  private
    def set_default_price
      if price.blank?
        if visit_type_id
          price = visit_type.price
        elsif payment_method_id == 3
          price = job_type.salary_amount
        else
          price = job_type.hour_price
        end
      end
    end

    def update_related_visit_price
      if self.visit_type
        self.visit_type.visits.price_editable_visits.each do |visit|
          visit.update_visit_total_price
        end
      end
    end

    def update_related_hours_price
      if self.hour_type
        self.hour_type.hours.price_editable_hours.each do |hour|
          hour.update_hour_total_price
        end
      end
    end
end
