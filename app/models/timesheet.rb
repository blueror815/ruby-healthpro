class Timesheet < ActiveRecord::Base
  # associations
  belongs_to :payroll
  belongs_to :user
  has_many :visits
  has_many :hours
  has_many :line_items
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy


  #validations
  validates :user_id, presence: true

  # callbacks
  before_create :set_last_timesheet_visits_avg
  after_create :set_delayed_jobs
  # scopes
  # scope :pending, lambda { where(state: 2)}
  # scope :paid, lambda { where(state: 4)}

  enum state: { created: 1, submitted: 2, admitted: 3, paid: 4 }



  def update_total_paid
    hash = {}
    hash[:visits] = self.visits.where(progress_state: 'paid')
    hash[:hours] = self.hours.where(progress_state: 'paid')
    hash[:on_call] = self.line_items.on_calls.where(progress_state: 'paid')
    hash[:reimb] = self.line_items.reimb.where(progress_state: 'paid')
    hash[:bonus] = self.line_items.bonus.where(progress_state: 'paid').try(:payable).try(:price)
    hash[:fixed_salery] = self.user.fixed_salery
    self.total_paid = ApplicationController.helpers.calculate_total_price(hash)
    self.save!
  end

  def self.send_email_to_owner(timesheet_id)
    @timesheet = Timesheet.find(timesheet_id)
    Notifier.send("#{@timesheet.state}_timesheet_report", @timesheet).deliver
  end

  def set_last_timesheet_visits_avg
    last_timesheet = self.user.timesheets.last
    self.previous_visits_avg  = if last_timesheet
      last_timesheet.timesheet_visits_avg
    else
      0
    end
  end

  def timesheet_visits_avg
    user = User.find(self.user_id)
    payroll_count = user.timesheets.count
    (self.previous_visits_avg.to_f  * (payroll_count -1 ) + self.visits.count ) / payroll_count
  end

  def set_delayed_jobs
    Delayed::Job.enqueue(TimesheetStatesJob.new(self.id, 'submitted'), run_at: self.payroll.submission_date)
    Delayed::Job.enqueue(TimesheetStatesJob.new(self.id, 'admitted'), run_at: self.payroll.admission_date)
  end
end
