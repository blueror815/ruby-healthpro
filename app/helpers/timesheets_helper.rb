module TimesheetsHelper
  def price_sum(action)
    price = 0
    if activities = action.sections_data.values.first['activities']
      visit_activities = CustomForms::CustomForm.find_by(title: 'activity').form_data.where(id: activities)
      visit_activities.map(&:sections_data).each do |activity|
        activity.each do |_k, section|
          price += section['price'].to_i if section['price']
        end
      end
    elsif current_user.job_type.payment_method_ids.include? '2' # && !current_user.job_type.hour_price.nil?
      price += current_user.job_type.hour_price[action.sections_data.values.first['hours type']].to_i * action.sections_data.values.first['hours'].to_i
    end
    price
  end

  # TODO: this method need to be refactored !
  def timesheet_total_price(paied_actions = [])
    paied_actions.reject!(&:blank?)
    total_price = 0
    paied_actions.each do |paied_action|
      if paied_action.is_a? Numeric
        total_price += paied_action
      else
        paied_action.each do |act|
          total_price += price_sum(act)
        end
      end
    end
    total_price
  end

  def submittable?(timesheet)
    timesheet.created?
    # timesheet.created? && timesheet.payroll.ended?
  end

  def admittable?(timesheet, user)
    timesheet.submitted?
    #timesheet.submitted? && current_user.departments.any? && !current_user.departments.where(id: user.departments).empty?
  end

  def payable?(timesheet)
    timesheet.admitted?
  end

  def calculate_total_price(args = {})
    visits_total_price = 0
    hours_total_price = 0
    on_call_total_price = 0
    reimb_total_price = 0
    if args[:visits]
      visits_total_price = args[:visits].map(&:total_price).inject{|total_price, visits_total_price| total_price.to_f + visits_total_price.to_f}
    end

    if args[:hours]
      hours_total_price = args[:hours].map(&:total_price).inject{|total_price, hours_total_price| total_price.to_f + hours_total_price.to_f}
    end

    if args[:on_call]
      u_price = args[:on_call].last.try(:payable).try(:user).try(:on_call_price)
      on_call_total_price = u_price * args[:on_call].length if u_price
    end

    if args[:riemb]
      args[:riemb].map(&:payable).each do |re|
        reimb_total_price += if re.reimbursement.value_type == 3
                               re.amount
                             elsif re.reimbursement.value_type == 1
                               re.reimbursement.price
                             else
                               (re.reimbursement.price * re.action_count)
                             end
      end
    end
    total_price = visits_total_price.to_f + hours_total_price.to_f + (args[:fixed_salery] || 0) + 
                  on_call_total_price.to_f + reimb_total_price.to_f + (args[:bonus].to_f || 0)
    total_price = args[:text] + total_price.to_s if args [:text]
    total_price
  end

  def reimbursement_price(reimb)
    if reimb.payable.reimbursement.value_type == 3
      number_to_currency(reimb.payable.amount)
    elsif reimb.payable.reimbursement.value_type == 1
      number_to_currency(reimb.payable.reimbursement.price)
    else
      number_to_currency(reimb.payable.reimbursement.price * reimb.payable.action_count.to_i)
    end
  end

  def editable?(v)
    (v.timesheet.user == current_user) and (v.timesheet.state == "created" || v.timesheet.state == "submitted")
  end
  
  def render_row_time_data(v)
    editable = (editable? v) ? "editable" : "static"
    render partial: "timesheets/show/shared/activity/#{editable}/time", locals: {v: v}
  end

  def render_row_reimbursements_data(v)
    editable = (editable? v) ? "editable" : "static"
    render partial: "timesheets/show/shared/activity/#{editable}/reimbursements", locals: {v: v}
  end

  def render_visit_row(v)
    render partial: "timesheets/show/shared/visit_row", locals: {v: v}
  end

  def render_visit_state(timesheet, visit)
    content_tag(:span, visit.progress_state) +
    if timesheet.state == "created" and timesheet.user == current_user
      content_tag(:span, ", ") + render_change_visit_state(timesheet, visit) 
    elsif  timesheet.state == "submitted"
      if can? :admit, Timesheet
        content_tag(:span, ", ") + render_change_visit_state(timesheet, visit) 
      else
        content_tag(:span, "")
      end
    else
      content_tag(:span, "")
    end 
  end

  def render_change_visit_state(timesheet, visit)
    user = @user ? @user : current_user
    if visit.progress_state == "visited"
       text, state = "Add", "pending"
    elsif visit.progress_state == "pending"
      if timesheet.user == current_user
        text, state = "remove", "visited"
      else
        text, state = "Approve", "approved"
      end
    else
      text, state = "Unknown", nil
    end  
    link_to text, update_task_state_path(id: timesheet.id, task_id: [visit.id], state: state, task_type: 'visit', user_id: user.id), class: "text-primary ink-reaction" , :remote => true 
  end

  def billed_visit_title(visit)
    "##{visit.id} #{visit.visit_type.title} - #{visit.patient.display_name}"
  end

  def billed_hour_title(hour)
    "##{hour.id} #{hour.hour_type.title} - #{hour.hours}"
  end
end
