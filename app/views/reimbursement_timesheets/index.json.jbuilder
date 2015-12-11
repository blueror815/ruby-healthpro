json.array!(@reimbursement_timesheets) do |reimbursement_timesheet|
  json.extract! reimbursement_timesheet, :id, :reimbursement_id, :timesheet_id, :progress_state, :action_count, :comment
  json.url reimbursement_timesheet_url(reimbursement_timesheet, format: :json)
end
