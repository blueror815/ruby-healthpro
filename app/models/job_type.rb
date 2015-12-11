class JobType < ActiveRecord::Base
  # associations
  has_many :license_types
  has_many :document_types
  has_many :users
  has_many :payment_rates, through: :users
  has_many :job_type_forms
  has_many :custom_forms, through: :job_type_forms
  has_many :job_types_visit_types
  has_many :visit_types, through: :job_types_visit_types
  has_and_belongs_to_many :hour_types

  # callbacks
  after_create :create_default_document_type
  before_destroy :has_users_with_this_title?
  before_create :set_default_payment_method_ids

  # constants
  PAYMENT_METHODS = { '1'=> 'per visit', '2'=> 'hourly', '3'=> 'fixed salary', '4' => 'reimbursement', '5' => 'on call', '6' => 'timesheet reimb'}

  # validations
  validates :title, presence: true, length: { maximum: 60 }
  validate :hour_price_presence

  private
    def set_default_payment_method_ids
      self.payment_method_ids = ['1', '2', '3'] if self.payment_method_ids.empty?
    end

    def salary_amount_presence
      if payment_method_ids.include?('3')
        errors.add(:salary_amount, "can't be blank") if salary_amount.blank?
      else
        salary_amount = nil
      end
    end

    def hour_price_presence
      if payment_method_ids.include?('2')
        errors.add(:hour_price, "can't be blank") if hour_price.blank?
      else
        salary_amount = nil
      end
    end

    def create_default_document_type
      document_types.create(document_name: 'resume')
    end

    # check if any user uses this job title prevent destroy
    def has_users_with_this_title?
      unless users.empty?
        errors.add(:discipline, "not deleted as it is associated with users")
        return false
      end
    end
end
