class PayrollCreationJob < Struct.new(:payroll_id)
  def perform
    last_payroll = Payroll.find(payroll_id)
    payroll_configurations = AdminConfiguration.find_by(title: 'payroll').configurations
  	end_date = last_payroll.end_date + payroll_configurations['period']['days'].to_i * 1.day + payroll_configurations['period']['hours'].to_i * 1.hour
  	submission_date = end_date + payroll_configurations['submission_allowance']['days'].to_i * 1.day + payroll_configurations['submission_allowance']['hours'].to_i * 1.hour
  	admission_date = submission_date + payroll_configurations['admission_allowance']['days'].to_i * 1.day + payroll_configurations['admission_allowance']['hours'].to_i * 1.hour
  	payroll = Payroll.create(start_date: last_payroll.end_date + 1.minute, 
  		end_date: end_date, 
  		submission_date: submission_date, 
  		admission_date: admission_date)
  end
end