class TimesheetStatesJob < Struct.new(:timesheet_ids, :state, :running_time)
  def perform
    timesheets = Timesheet.where(id: timesheet_ids)
    timesheets.find_each do |timesheet|
      if state == 'submitted' && timesheet.created? || state == 'admitted' && timesheet.submitted?
         timesheet.update(state: state)
      end
    end
  end
end