class OnCall < ActiveRecord::Base
  
  # associations
  has_many :line_items, as: :payable
  belongs_to :user
  belongs_to :timesheet
  has_many :comments, :as => :commentable, dependent: :destroy
  has_many :notifications, :as => :notifiable, dependent: :destroy

  #validation
  validates :note, presence: true
  validates :date, presence: true

  #constants
  PROGRESS_STATE = %w(logged pending approved admited paid rejected)

  # callback
  before_save :init_progress_state
  after_create :link_to_line_item

  private
  def link_to_line_item
    LineItem.create_new_item('OnCall', self.id, self.timesheet_id)
  end

  def init_progress_state
    unless self.progress_state 
      self.progress_state = 'logged'
    end
  end
end
