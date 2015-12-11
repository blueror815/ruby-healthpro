json.extract! @reimbursement, :id, :title, :value_type, :price, :include_in_timesheet
json.data do 
  json.set! :"DT_RowId", @reimbursement.id
  json.set! :title, @reimbursement.title
  json.set! :price, @reimbursement.price
  json.set! :value_type, @reimbursement.value_type
  json.set! :include_in_timesheet, @reimbursement.include_in_timesheet
end
