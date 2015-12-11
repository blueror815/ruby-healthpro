class TimesheetPresenter < BasePresenter
  presents :timesheet

  #returns the timesheet owner
  def assignee_link
    h.link_to timesheet.user.display_name, h.user_path(timesheet.user_id)
  end

  #returns the number of items in timesheet that are waiting for approval
  def pending_items_count
    #TODO_PROHEALTH need to be refactor after using lineitems 
    no_of_pending_visits = timesheet.visits.where(progress_state: 'pending').count
    no_of_pending_hours = timesheet.hours.where(progress_state: 'pending').count
    no_of_pending_line_items = timesheet.line_items.where(progress_state: 'pending').count
    no_of_pending_visits + no_of_pending_hours + no_of_pending_line_items
  end

  #returns the number of items in timesheet that are waiting for approval
  def rejected_items_count
    #TODO_PROHEALTH need to be refactor after using lineitems 
    no_of_rejected_visits = timesheet.visits.where(progress_state: 'rejected').count
    no_of_rejected_hours = timesheet.hours.where(progress_state: 'rejected').count
    no_of_rejected_line_items = timesheet.line_items.where(progress_state: 'rejected').count
    no_of_rejected_visits + no_of_rejected_hours + no_of_rejected_line_items
  end

  def total_visits_numbers
    no_of_visits = timesheet.visits.count
  end

  def payroll_date
    date timesheet.payroll.end_date
  end

  def timesheet_paid_amount
    number_to_currency((timesheet.total_paid || 0))
  end

  def timesheet_unapproved_amount
    prices_hash = {}
    prices_hash[:visits] = timesheet.visits.where(progress_state: 'rejected')
    prices_hash[:hours] = timesheet.hours.where(progress_state: 'rejected')
    prices_hash[:on_call] = timesheet.line_items.on_calls.where(progress_state: 'rejected')
    prices_hash[:reimb] = timesheet.line_items.reimb.where(progress_state: 'rejected')
    number_to_currency(calculate_total_price(prices_hash))
  end
end