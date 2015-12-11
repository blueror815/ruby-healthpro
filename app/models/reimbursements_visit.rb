class ReimbursementsVisit < ActiveRecord::Base

  #validations
  validate :action_count_values

  # associations
  belongs_to :reimbursement
  belongs_to :visit

  def price
    reimbursement.price
  end

  private
  def action_count_values
    if self.reimbursement.value_type == 1 && self.action_count > 1 #single instance
      errors.add(:action_count, "can't be any value other than 1 for single instance reimbursements.")
    elsif self.reimbursement.value_type == 2 && self.action_count < 0 #mutliple instances
      errors.add(:action_count, "can't be less than 0 for mutliple instance reimbursements.")
    end
  end



end
