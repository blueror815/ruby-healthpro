class HourType < ActiveRecord::Base
  # associations
  has_and_belongs_to_many :job_types
  has_and_belongs_to_many :departments
  has_many :hours

  # validations
  validates :title, presence: true, length: { maximum: 60 }
  validates :price_factor, presence: true
  validates :price_factor, numericality: { greater_than_or_equal_to: 0 }, if: lambda { |object| object.price_factor.present? }

  # call backs
  after_save :update_hour_total_price

  # scopes
  scope :over_time, -> {where title: 'Over Time'}

  private
    def update_hour_total_price
      if self.price_factor_changed?
        self.hours.price_editable_hours.each do |hour|
          hour.update_hour_total_price
        end
      end
    end
end
