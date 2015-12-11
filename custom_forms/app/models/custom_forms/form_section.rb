module CustomForms
  class FormSection < ActiveRecord::Base
    self.table_name = 'form_sections'

    # associations
    belongs_to :custom_form
    has_many :section_fields, -> { order(:row_order) }
    has_many :field_types, through: :section_fields

    # callbacks
    before_destroy :validate_form_sections_length
    before_destroy :destroy_section_fields

    accepts_nested_attributes_for :section_fields, allow_destroy: true

    # validations
    validates :title, presence: true, length: { maximum: 30 }
    validates :title, uniqueness: { scope: :custom_form_id }
    validates :section_fields, length: { minimum: 1 }

    private
      def validate_form_sections_length
        if self.custom_form.form_sections.length < 2
          self.custom_form.errors.add(:form_section, "can not be less than 1")
          return false
        end
      end

      def destroy_section_fields
        SectionField.skip_callback :destroy, :before, :section_fields_length
        self.section_fields.destroy_all
      end
  end
end
