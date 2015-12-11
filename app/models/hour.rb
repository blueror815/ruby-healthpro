class Hour < ActiveRecord::Base
  # associations
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id'
  belongs_to :hour_type
  belongs_to :timesheet
  has_many :comments, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :comments

  # validation 
  validates :from, presence: true
  validates :to, presence: true
  validates :hour_type_id, presence: true
  validates :assignee, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :from, :to, overlap: { scope: ['assignee_id', 'date'] }
  validate :time_in_before_time_out

  # callback
  before_save :set_total_price
  before_save :init_progress_state
  # before_save :update_price, if: :hours_changed?

  # scopes
  scope :price_editable_hours, -> { where(progress_state: ['logged', 'pending']) }

  PROGRESS_STATE = %w(logged pending approved admited paid rejected)

  def update_hour_total_price
    self.set_total_price
    self.save!
  end

  def hours
    if to && from
      (self.to - self.from)/1.hour
    else
      0
    end
  end

  def user
    self.assignee
  end
  
  def set_total_price
    if ['logged', 'pending'].include? self.progress_state
      hour_total_price = (self.hours * self.hour_price.to_f ).to_s
      self.total_price =  hour_total_price
    end
  end

  def hour_price
    if self.assignee
      factor = self.hour_type.try(:price_factor) || 1
      price = self.assignee.job_type.try(:hour_price) || 0
      if self.assignee.payment_rates
        rates = self.assignee.payment_rates
        hour_rate = rates.find_by(payment_method_id: 2)
        if hour_rate
          price = hour_rate.try(:price) || price
        end
      end
      price * factor
    else
      0
    end
  end

  private
    def init_progress_state
      unless self.progress_state
        self.progress_state = 'logged'
      end
    end

    def time_in_before_time_out
      if !from.nil? && !to.nil? && from >= to
        errors.add(:to, 'must be before from time')
      end
    end
end
