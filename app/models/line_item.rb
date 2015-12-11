class LineItem < ActiveRecord::Base
  # associations
  belongs_to :payable, polymorphic: true
  belongs_to :timesheet

  # validation 
  validates :timesheet_id, presence: true
  validates :payable_id, presence: true
  validates :payable_type, presence: true

  # scopes
  scope :on_calls, -> { where(payable_type: 'OnCall')}
  scope :reimb, -> { where(payable_type: 'ReimbursementTimesheet')}
  scope :bonus, -> { where(payable_type: 'Bonuse')}

  def self.create_new_item(payable_type, payable_id, timesheet_id)
    LineItem.create(payable_type: payable_type, payable_id: payable_id, timesheet_id: timesheet_id, progress_state: 'pending')
  end
end
