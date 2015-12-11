class Notifier < ApplicationMailer

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def submitted_timesheet_report(timesheet)
    @timesheet = timesheet
    mail( :to => @timesheet.user.email, :subject => 'Submitted Timesheet Report' )
  end

  def created_timesheet_report(timesheet)
    @timesheet = timesheet
    mail( :to => @timesheet.user.email, :subject => 'Submitted Timesheet Report' )
  end

end
