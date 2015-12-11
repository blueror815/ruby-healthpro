module CustomForms
  class FieldType < ActiveRecord::Base
    self.table_name = 'field_types'

    validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 35 }
    validates :field_type, presence: true
    validate :options_presence
    validate :options_uniqueness

    has_many :section_fields, -> { order(:row_order) }
    has_many :form_sections, through: :section_fields
    has_and_belongs_to_many :report_fields

    # instance methods
    def humanized_name
      name.humanize
    end

    private
      # custom validator
      def options_uniqueness
        if options && options['options']
          options['options'] = options['options'].split(',').map(&:strip).join(',')
        end
      end

      def options_presence
        if field_type == 'select'
          errors.add(:options, "can't be blank") if options['options'].blank?
        end
      end
  end
end
