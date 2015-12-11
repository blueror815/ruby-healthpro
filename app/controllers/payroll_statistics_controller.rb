class PayrollStatisticsController < ApplicationController

  #filters
  before_action :set_payroll, only: [:get_exceeded_employees, :show_employees_visits_per_patient, :show_top_ten_employees, :show_employees_with_reimb, :show_employees_with_over_time]
  before_action :payroll_timesheets, only: [:get_exceeded_employees, :show_employees_visits_per_patient, :show_top_ten_employees, :show_employees_with_reimb, :show_employees_with_over_time]
  before_action :set_payroll_visits, only: [:show_employees_visits_per_patient, :show_top_ten_employees]

  #get employees that make 10% vists more than thier avarage 
  def get_exceeded_employees
  end

  #get employees vists per patient 
  def show_employees_visits_per_patient
    visits = set_payroll_visits
    @grouped_visits = visits.group_by{|visit| [visit.assignee.try(:display_name), visit.patient.try(:display_name)]}.map do |k, v|
      no_user_patients_per_timesheet = v.first.timesheet.visits.map(&:patient_id).try(:count)
      avg_visits_per_patient = v.count.to_f / no_user_patients_per_timesheet.to_f
      {employee_name: k.first, patient_name: k.last, avg: avg_visits_per_patient.round(2)}
    end
  end

  #get top ten employees
  def show_top_ten_employees
    visits = set_payroll_visits
    @grouped_visits = visits.group_by{|v| v.assignee.try(:display_name)}.sort_by {|k, v| v.count}.first(10).map do |emp_name, visits|
      {employee_name: emp_name, visits_count: visits.count}
    end.reverse!
  end

  #show all employees in the payroll that has reimbursements
  def show_employees_with_reimb
    reimb_line_items = set_payroll_reimb
    @groupd_reimb = reimb_line_items.group_by{|reimb_li| reimb_li.payable.user.try(:display_name)}.map do |emp_name, reimb|
      {employee_name: emp_name, reimb_count: reimb.count}
    end
  end

  #show all employees with over time 
  def show_employees_with_over_time
    over_time_objs = set_payroll_overtimes
    @groupd_hours = over_time_objs.group_by{|hour| hour.assignee.try(:display_name)}.map do |emp_name, hour|
      sum = 0
      sum = hour.map(&:hours).inject{|sum, x_hours| sum + x_hours}
      {employee_name: emp_name, hours: sum}
    end
  end

  private
  # set payroll from params id 
  def set_payroll
    @payroll = Payroll.find(params[:id])
  end

  #set timesheets for the selected payroll
  def payroll_timesheets
    @payroll_timesheets = @payroll.timesheets.includes(:user)
  end

  #set payroll visits
  def set_payroll_visits
    Visit.where(timesheet_id: @payroll_timesheets.map(&:id))
  end

  #set timesheet's line item from reimb type 
  def set_payroll_reimb
    LineItem.reimb.where(timesheet_id: @payroll_timesheets.map(&:id))
  end

  # set payroll hours type overtime 
  def set_payroll_overtimes
    over_time = HourType.over_time.try(:last)
    if over_time
      Hour.where(timesheet_id: @payroll_timesheets.map(&:id), hour_type_id: over_time.id)
    else
      []
    end
  end
end
