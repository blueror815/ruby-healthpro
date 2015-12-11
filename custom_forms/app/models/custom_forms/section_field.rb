module CustomForms
  class SectionField < ActiveRecord::Base
    self.table_name = 'form_sections_field_types'

    # associations
    has_one :attachment
    belongs_to :field_type
    belongs_to :form_section

    # callbacks
    before_update :has_form_data?
    before_save :set_field_alias
    before_destroy :section_fields_length
    after_create :update_users_forms

    # validaitons
    validates :field_type, presence: true
    validates :field_alias, uniqueness: { case_sensitive: false, scope: :form_section_id }

    private
      def section_fields_length
        if self.form_section.section_fields.length < 2
          return false
        end
      end

      def has_form_data?
        if field_type_id_changed?
          if form_section.custom_form.form_data.any?
            return false
          end
        end
      end

      def set_field_alias
        if self.field_alias.blank?
          self.field_alias = field_type.name.humanize
        end
      end

      #update user forms 
      def update_users_forms
        custom_form_id = self.form_section.custom_form.id
        FormDatum.delay.update_forms_with_new_field(custom_form_id, self)
      end
  end
end
