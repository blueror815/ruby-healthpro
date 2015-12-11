class Bonuse < ActiveRecord::Base

  # associations
  has_many :line_items, as: :payable
  belongs_to :user

  #validation
  validates :price, presence: true
  validates :timesheet_id, uniqueness: true

  #constants
  PROGRESS_STATE = %w(approved admited paid)

  # callback
  after_create :link_to_line_item

  private

  def link_to_line_item
    LineItem.create_new_item('Bonuse', self.id, self.timesheet_id)
  end


end
