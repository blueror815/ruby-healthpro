class Payroll < ActiveRecord::Base

  #associations
  has_many :timesheets, dependent: :destroy
  
  #callbacks
  before_save :set_dates
  after_create :create_timesheets

  #validations
  validates :start_date, presence: true
  validates :start_date, :end_date, :overlap => true
  validate :start_date_must_be_before_end_date

  def ended?
    Time.zone.now > self.end_date
  end

  def as_json(options={})
   { title: "Pay period ##{self.id}",
     start: self.start_date.strftime('%Y, %m, %d'),
     end: (self.end_date + 1).strftime('%Y, %m, %d'),
     allDay: true }
  end
  
  private
    def set_dates
      payroll_configurations = AdminConfiguration.find_by(title: 'payroll').configurations
      self.end_date = self.start_date + payroll_configurations['period']['days'].to_i * 1.day + payroll_configurations['period']['hours'].to_i * 1.hour
      self.submission_date = self.end_date + payroll_configurations['submission_allowance']['days'].to_i * 1.day + payroll_configurations['submission_allowance']['hours'].to_i * 1.hour
      self.admission_date = self.submission_date + payroll_configurations['admission_allowance']['days'].to_i * 1.day + payroll_configurations['admission_allowance']['hours'].to_i * 1.hour
      # for debugging purposes, you may pry here and change end/submission/admission dates to shorter ones
    end

  def create_timesheets
    Delayed::Job.enqueue(PayrollCreationJob.new(self.id), run_at: self.end_date)
  end

  def start_date_must_be_before_end_date
    if !start_date.nil? && !end_date.nil? && start_date >= end_date
      errors.add(:start_date, 'must be before end date')
    end
  end
end
