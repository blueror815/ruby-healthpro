class TimesheetsCreationJob < Struct.new(:payroll_id)
  def perform
    payroll = Payroll.find(payroll_id)
    timesheet_ids = []
    User.find_each do |u|
      timesheet = payroll.timesheets.create(user_id: u.id)
      timesheet_ids << timesheet.id
    end
    Delayed::Job.enqueue(TimesheetStatesJob.new(timesheet_ids, 'submitted'), run_at: payroll.submission_date)
    Delayed::Job.enqueue(TimesheetStatesJob.new(timesheet_ids, 'admitted'), run_at: payroll.admission_date)
    Delayed::Job.enqueue(PayrollCreationJob.new(payroll_id), run_at: payroll.end_date)
  end
end

