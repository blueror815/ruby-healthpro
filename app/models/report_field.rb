class ReportField < ActiveRecord::Base
  # associations 
  belongs_to :report
  has_and_belongs_to_many :field_types, class_name: 'CustomForms::FieldType'

  # validations
  validates :field_type, presence: true
  validate :start_date_must_be_before_end_date

  private
    def start_date_must_be_before_end_date
      if self.field_type == 'date_interval' && self.value_options['days'].blank?
        if self.value_options['from'].to_date.present? && self.value_options['to'].to_date.present?
          if Date.parse(self.value_options['from']) >= Date.parse(self.value_options['to'])
            errors.add(:from_date, 'must be before to date')
          end
        end
      end
    end
end
